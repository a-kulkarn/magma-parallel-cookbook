// Process designed to hang as the manager process exits.

host := "localhost";
port := 10000;

function snooze(n)
    while true do
        Sleep(10);
    end while;
    return 0;
end function;

Sleep(1);
DistributedWorker(host, port, snooze);
exit;
