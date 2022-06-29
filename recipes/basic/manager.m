AttachSpec("../../spec");
socket := Socket(: LocalHost := "localhost", LocalPort := 10000);
StartDistributedWorkers("worker.m", 3);
results := DistributedManager(socket, [1..10]);

// Print something to get the prompt back.
print "";

// Resource cleanup.
delete socket;
