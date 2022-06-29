AttachSpec("../../spec");
socket := Socket(: LocalHost := "localhost", LocalPort := 10000);
StartDistributedWorkers("worker.m", 3);

function RaceTask(n)
    return [], [1..n];
end function;

function RaceUpdate(item, task, tresult, gresult)
    return tresult, [], true;
end function;

results := DistributedManager(socket, [2] : group_tasks := RaceTask,
                                            update_group := RaceUpdate);

// Print something to get the prompt back.
print "";

// Resource cleanup.
delete socket;
