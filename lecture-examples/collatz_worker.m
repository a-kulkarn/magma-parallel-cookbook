//////////////////////////////////////////
// Worker in parallelism example.

// Same as the manager process.
host := "localhost";
port := 10000;

procedure sleep_ms(ms)          // "sleeps" for the given number of milliseconds
    _ := WaitForIO([] : TimeLimit := ms);
end procedure;

// Functions related to actual work
collatz := func<n | IsEven(n) select n div 2 else 3*n + 1>;
function collatz_info(n)
    k := n;
    niters := 0;
    maxval := k;
    while k gt 1 do
        k := collatz(k);
        niters +:= 1;
        maxval := Max(maxval, k);
    end while;
    sleep_ms(10*Random(1, 3));        // random delay for example purposes only
    return <n, niters, maxval>;
end function;

// Give the manager time to set up the Socket
sleep_ms(10);

// Activate the worker
DistributedWorker(host, port, collatz_info);

// Terminate the worker once it is done.
quit;
