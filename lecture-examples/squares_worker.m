//////////////////////////////////////////
// Worker in parallelism example.

// Same as the manager process.
host := "localhost";
port := 10000;

procedure sleep_ms(ms)          // "sleeps" for the given number of milliseconds
    _ := WaitForIO([] : TimeLimit := ms);
end procedure;

// Functions related to actual work
function issolvable_local(eqn_data)
    a := eqn_data[1];
    q := eqn_data[2]; // This is a prime power
    F := Integers(q);
    return IsSquare(F ! a);
end function;

// Give the manager time to set up the Socket
sleep_ms(10);

// Activate the worker
DistributedWorker(host, port, issolvable_local);

// Terminate the worker once it is done.
quit;
