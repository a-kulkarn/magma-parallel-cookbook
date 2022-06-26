
// Process should generate orphans somehow
socket := Socket(: LocalHost:="localhost", LocalPort:=10000);

function makeTasks(n)
    return [], [1..10];
end function;

function collectResults(item, task, tresult, gresult)
    return 0, [], true;
end function;

// Start the orphans
for i in [1..9] do
    System("magma -b orphan.m &"); // Launch and detach the worker.
end for;

// Start an efficient worker
System("magma -b oliver.m &");

DistributedManager(socket, [1] :
                   group_tasks := makeTasks,
		   update_group := collectResults);
