// oliver.m
// Fast process that returns quickly.

function foo(n)
    return 0;
end function;

Sleep(1);
DistributedWorker("localhost", 10000, foo);
exit;
