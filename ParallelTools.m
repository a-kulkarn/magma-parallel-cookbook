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
    call_string := Sprintf("(sleep 0.01 && magma -b %o) &", file);
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
