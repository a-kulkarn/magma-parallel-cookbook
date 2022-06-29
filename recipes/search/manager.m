AttachSpec("../../spec");
socket := Socket(: LocalHost := "localhost", LocalPort := 10000);
StartDistributedWorkers("worker.m", 3);

function SearchTask(box)
    return "Not Found Default", box;
end function;

function SearchUpdate(item, task, tresult, gresult)
    found, data := Explode(tresult);
    
    if found then
        return data, [], true;
    else
        return gresult, [], false;
    end if;
end function;

box := [1..100];
results := DistributedManager(socket, [box] : group_tasks := SearchTask,
                                              update_group := SearchUpdate);


// Print something to get the prompt back.
print "";

// Resource cleanup.
delete socket;
