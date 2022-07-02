AttachSpec("../../spec");
socket := Socket(: LocalHost := "localhost", LocalPort := 10000);
StartDistributedWorkers("worker.m", 3);

timeout := 3;
NOT_DONE := "NOT_DONE";

function RaceTask(n)
    ginit := [* NOT_DONE : i in [1..n] *];
    tasks_we_want_to_do := [2*i : i in [1..n]];
    TWWTD := tasks_we_want_to_do;
    
    enumerate_tasks := [<false, i, TWWTD[i]> : i in [1..#TWWTD]];
    
    return ginit, [* <true, 0, timeout> *] cat [* tup : tup in enumerate_tasks *];
end function;

function RaceUpdate(item, task, tresult, gresult)
    // Check the task to see if it is the timeout task and set the done flag accordingly.
    timeout_flag, index, _ := Explode(task);

    if timeout_flag then
        // Also should keep track of number of finished jobs.
        return gresult, [], true;
    else
        gresult[index] := tresult;

        done := true;
        for i in [1..#gresult] do
            if gresult[i] cmpeq NOT_DONE then
                done := false;
                break;
            end if;
        end for;
        
        return gresult, [], done;
    end if;
end function;

results := DistributedManager(socket, [2] : group_tasks := RaceTask,
                                            update_group := RaceUpdate);

// Print something to get the prompt back.
print "";

// Resource cleanup.
delete socket;
