// Same as the manager process.
host := "localhost";
port := 10000;

// Functions related to actual work
function Timer(arg)
    Sleep(arg); return arg;
end function;

function YourFunctionHere(arg)
    Sleep(arg); return arg;
end function;


function Derby(input)
    timeout_flag, _, arg := Explode(input);
    case timeout_flag:
    when true: return Timer(arg);
    when false: return YourFunctionHere(arg);
    else
        error "Not implemented for given input. Perhaps add more cases?";
    end case;
end function;

// Activate the worker
DistributedWorker(host, port, Derby);

// Terminate the worker once it is done.
quit;
