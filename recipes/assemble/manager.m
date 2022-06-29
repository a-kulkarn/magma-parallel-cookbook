////////////////////////////////////////////////////////////////////////////////
//
// Parallel Assembly Pattern
//
// This is the most complicated recipe in the cookbook thusfar. The basic point
// of this pattern is to "build up" a fairly complicated structure via asynchronous
// workers assmbling parts of it, and then sending these parts back to a master
// process to update the main structure.
//
// Such a task is orgainized into a number of different steps
//
//  1. Creation of the foundation of the structure, and initializing the jobs
//     based on the input.
//
//  2. Dividing the total construction into components that asynchronous workers
//     can make progress on. The workers may receive a version of the "structure
//     in progress". 
//
//  3. Workers return a partial result, and possibly some additional data.
//
//  4. The main structure is updated with the result of the worker.
//
//  5. Using the additional data returned by the worker, and the current state of
//     the structure, new jobs are added into the queue to be done.
//
//  6. Eventually the task is completed, and the main structure is returned.
//
// A good example of this kind of pattern is the creation of a (parellel) breadth-
// first-search-tree. Here, the partially constructed tree is  passed to a
// worker and the new nodes to be considered are returned, to be added into the
// jobs queue.
//
// The example code does something slightly simpler. The "ParallelAssembler" here
// takes in a list of positive integers and returns an associative array `G`. The
// value `G[n]` is the number of applications of the Collatz function it takes to
// reach `1` (conjecturally this is finite). Each worker explores a path within the
// "Collatz Graph", and the `UpdateStructure` method merges this information into
// the main associative array. When future workers are launched, they also recieve
// this updated structure, so if a previously visited value is encountered the
// worker can use this information to shortcut out of the computation.
//
////////////////////////////////////////////////////////////////////////////////

AttachSpec("../../spec");

function ParallelAssembler(input)

    // Guard clauses, if necessary.
    if IsEmpty(input) then
        return AssociativeArray();
    end if;

    /////////////////////////////////
    // Functions to manipulate the Queue of Jobs under consideration.
    
    function GenerateNewJobs(G)
        // This sub-function may also use the provided `input` to decide what
        // jobs to generate.
        return [];
    end function;
    
    function CreateInitialJobs(initialJobs)
        G := AssociativeArray();
        G[1] := 0;
        return G, [<G, x> : x in initialJobs];
    end function;
    /////////////////////////////////

    /////////////////////////////////
    // Functions to update the main structure based on the work done thusfar.
    
    function Merge(current_state, task_result)
        for k in Keys(task_result) do
            current_state[k] := task_result[k];
        end for;
        
        return current_state;
    end function;
        
    function UpdateStructure(item, task, tresult, gresult)

        // Update step
        gresult  := Merge(gresult, tresult);

        // Create new work depending on the result of the computation. This step
        // is sometimes necessary, for example, consider a parallelized implementation of
        // breadth first search.
        //
        new_jobs := GenerateNewJobs(gresult); 
        
        // Need a task generator function.
        return gresult, new_jobs, false;
    end function;
    /////////////////////////////////

    // Launch parallel function.
    socket := Socket(: LocalHost := "localhost", LocalPort := 10000);
    StartDistributedWorkers("worker.m", 3);


    results := DistributedManager(socket, [input] :
                                  group_tasks := CreateInitialJobs, 
                                  update_group := UpdateStructure);
    // Resource cleanup.
    delete socket;

    return results[1];
end function;

results := ParallelAssembler([1..10]);

