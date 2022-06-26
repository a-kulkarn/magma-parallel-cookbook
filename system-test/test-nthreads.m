SetNthreads(1);
X := Random(MatrixRing(GF(5), 10000));
time P := X*X; // single thread, normal CPU time
// Time: 5.040
time E,T := EchelonForm(X);
// Time: 6.940
SetNthreads(4);
time P2 := X*X; // multi-threads, so real time shown by [r]
// Time: 1.760[r]
time E,T := EchelonForm(X);
// Time: 2.660[r]
assert P2 eq P;
