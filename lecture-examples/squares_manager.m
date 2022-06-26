// In this example, we use a task group to divide a computation into several local
// computations, and then coallate the results afterwards.

// The input consists of a collection of pairs (a, n). The output is a list of
// booleans indicating whether `a` is a square modulo `n`.

break_into_local_tasks := function(pairs)
    // Unpack data
    a := pairs[1];
    n := pairs[2];
    default_val := true;
    
    // NOTE: When n=1, no tasks are generated because `facts` is empty!
    if n eq 1 then
        return default_val, [<1,2>]; // Feed something to the worker that returns true.
    end if;
    
    // Divide into tasks
    facts := Factorization(n);
    return default_val, [<a, p[1]^p[2]> : p in facts];
end function;

combine_local_info := function(item, task, tresult, gresult)

    cansolve_local := tresult;
    cansolve := gresult; // Current value for group result.

    if not cansolve_local then
        eqstring := Sprintf("'X^2 = %o mod %o'", item[1], item[2]);
        print "Equation", eqstring,
              "cannot be solved because of obstruction at prime power", task[2];
        
        definitely_done := true;
        cansolve := false;
    else
        cansolve := cansolve and cansolve_local;
        definitely_done := false;
    end if;
        
    return cansolve, [], definitely_done;
end function;

bad_update_results := procedure(~results, result, index)
    if result eq true then
        results[index] := "Banana";
    else
        results[index] := "";
    end if;
end procedure;    


///////////////////////////////
// Begin script.

socket := Socket(: LocalHost := "localhost", LocalPort := 10000);

// Prepare input equations to check for solutions.
issquare_input := [<-1, n> : n in [1..100]] cat [<5, n> : n in [1..100]];

for i in [1..1] do
    System("magma -b squares_worker.m &"); // Launch and detach the worker.
end for;

results := DistributedManager(socket, issquare_input :
		              group_tasks := break_into_local_tasks,
		              update_group := combine_local_info,
                              update_results := bad_update_results
		             );

// Print something to get the prompt back.
print "";

