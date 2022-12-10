////////////////////////////////////////////////////////////////////////////////
//
// ParallelTools.m
//
// This is a small library to help with user-implemented parallelism in magma.
//
////////////////////////////////////////////////////////////////////////////////

intrinsic SleepMS(n)
{Sleeps for n milliseconds.}
    _ := WaitForIO([] : TimeLimit := n);
end intrinsic;

intrinsic StartDistributedWorkers(file, N)
{Start N DistributedWorker instances via system call, where the worker specifications
appear in the file `file`.}
    call_string := Sprintf("(export MAGMA_WORKER_INSTANCE=1 && sleep 0.10 && magma -b %o) &",
                           file);
    for i in [1..N] do
        // Launch and detach the worker with a slight delay to allow the manager
        // to set up the port.
        System(call_string);
    end for;
end intrinsic;

intrinsic ParallelMap(fun, L::SeqEnum : NumWorkers:=1) -> SeqEnum
{Return the Sequence [fun(x) : x in L] using a parallel implementation. Note that
the intrinsic `fun` must be available at magma startup, and cannot refer to any variables
assigned in the current session. Additionally, ParallelTools must be Attached on startup.}

    tempname := Tempname("verysafeprefix");
    func_str := Sprint(fun, "Magma");
    
    worker_code_string := Sprintf( "
SleepMS(5);
lambda := func<x | %o(x)>;
DistributedWorker(\"localhost\", 10000, lambda);
", func_str);

    try
        Write(tempname, worker_code_string);
        StartDistributedWorkers(tempname, NumWorkers);
    
        socket := Socket(: LocalHost:="localhost", LocalPort:=10000);
        results := DistributedManager(socket, L);
        System(Sprintf("rm %o", tempname));
        
        return results;
    catch e
        System(Sprintf("rm %o", tempname));
        error e;
    end try;
end intrinsic;

// Function to test Parallelism implementations.
intrinsic testSleep(x::RngIntElt) -> RngIntElt
{}
    Sleep(x);
    return 0;
end intrinsic;

intrinsic KillProcessOnPort(port)
{Kills all processes listening on the given port.}
    // TODO: Doesn't work on Mac...
    killString := Sprintf("killthese=$(fuser %o/tcp 2>/dev/null) && kill -9 $killthese", port);
    System(killString);
    return;
end intrinsic;

intrinsic IsWorkerProcess() -> BoolElt
{Determines if this file has been launched as a worker.}
    return GetEnv("MAGMA_WORKER_INSTANCE") eq "1";
end intrinsic;

intrinsic DefaultParallelSetup(: LocalHost := "localhost", LocalPort := 10000)
          -> MonStgElt, RngIntElt
{Return the default host/port/socket information.}
    return LocalHost, LocalPort;
end intrinsic;


intrinsic DoWorkThenDie(fun : LocalHost:="localhost", LocalPort:=10000)
{Launch a worker instance of the function `fun`. Connects to a currently
open manager process. Then terminate magma.}
    DistributedWorker(LocalHost, LocalPort, fun);
    quit;
end intrinsic;

intrinsic ActivateWorkers(tasks, filename
                            : Ncores:=1, LocalHost:="localhost", LocalPort:=10000) -> Any
{Runs the code in `file` in parallel, with workers receiving elements of `tasks` as input.}

    // Socket setup.
    socket := Socket(: LocalHost:=LocalHost, LocalPort:=LocalPort);
    
    StartDistributedWorkers(filename, Ncores);
    results := DistributedManager(socket, tasks);

    // Resource cleanup.
    delete socket;

    // TODO: Consider aggresively killing the workers still connected to the port.
    // KillProcessOnPort(LocalPort);

    // Return.
    return results;
end intrinsic;
