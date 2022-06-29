AttachSpec("../../spec");

// Same as the manager process.
host := "localhost";
port := 10000;

// Helper function
function collatz_step(n)
    return  IsEven(n) select ExactQuotient(n, 2) else 3*n + 1;
end function;

// Functions related to actual work
function YourFunctionHere(arg)
    SleepMS(5);
    G, x := Explode(arg);
    keys := Keys(G);

    // Prelude work to create the new part to attach onto the existing structure.
    new_entries := [];
    while x notin keys do
        Insert(~new_entries, 1, x);
        x := collatz_step(x);
    end while;

    // Create the part of the structure to be returned to the assembler.
    new_part_of_structure := AssociativeArray();
        
    for i in [1..#new_entries] do
        y := new_entries[i];
        new_part_of_structure[y] := G[x] + i;
    end for;
            
    return new_part_of_structure;
end function;

// Activate the worker
DistributedWorker(host, port, YourFunctionHere);

// Terminate the worker once it is done.
quit;
