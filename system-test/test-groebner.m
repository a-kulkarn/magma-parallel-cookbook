B := HFESystem(2, 80, 100);
SetNthreads(1);
time G := GroebnerBasis(B, 4: HFE, ReductionHeuristic := 1000);
// Time: 77.010
[Sprint(f): f in G];
Variety(Ideal(G));
SetNthreads(4);
time G := GroebnerBasis(B, 4: HFE, ReductionHeuristic := 1000);
//  Time: 26.990[r]
