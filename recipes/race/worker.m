// Same as the manager process.
host := "localhost";
port := 10000;

// Functions related to actual work
function YourFirstFunctionHere(arg)
    Sleep(1); return arg;
end function;

function YourSecondFunctionHere(arg)
    Sleep(1); return arg;
end function;


function Derby(arg)
    case arg:
    when 1: return YourFirstFunctionHere(arg);
    when 2: return YourSecondFunctionHere(arg);
    else
        error "Not implemented for given input. Perhaps add more cases?";
    end case;
end function;

// Activate the worker
DistributedWorker(host, port, Derby);

// Terminate the worker once it is done.
quit;
