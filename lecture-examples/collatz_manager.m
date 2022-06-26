socket := Socket(: LocalHost := "localhost", LocalPort := 10000);
SetVerbose("ManagerWorker", 2);

for i in [1..10] do
    System("magma collatz_worker.m &"); // Launch and detach the worker.
end for;

DistributedManager(socket, [1..10]);

// Print something to get the prompt back.
print "";

// Resource cleanup.
delete socket;
