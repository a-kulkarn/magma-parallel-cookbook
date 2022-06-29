// Same as the manager process.
host := "localhost";
port := 10000;

// Functions related to actual work
function YourFunctionHere(arg)
    Sleep(1);
    output := 0;
    return output;
end function;

// Activate the worker
DistributedWorker(host, port, YourFunctionHere);

// Terminate the worker once it is done.
quit;
