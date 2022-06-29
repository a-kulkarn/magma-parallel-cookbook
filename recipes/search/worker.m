// Same as the manager process.
host := "localhost";
port := 10000;

// Imports
AttachSpec("../../spec");


// Functions related to actual work
function YourSearchFunctionHere(arg)
    SleepMS(1);
    data := arg; // Or some other data as you prefer.
    found := arg eq 42 select true else false;
    if found then
        return <true, data>;
    else
        return <false, data>;
    end if;
end function;

// Activate the worker
DistributedWorker(host, port, YourSearchFunctionHere);

// Terminate the worker once it is done.
quit;
