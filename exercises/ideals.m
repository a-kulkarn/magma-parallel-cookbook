
R<x1,x2,x3,x4,x5,x6,x7,x8> := PolynomialRing(Rationals(), 8);

ideals := [* ideal<R | sys> : sys in systems *] where
systems := [
    [ x1+x2+x3+x4,
      x1 * x2+x2 * x3+x1 * x4+x3 * x4,
      x1 * x2 * x3+x1 * x2 * x4+x1 * x3 * x4+x2 * x3 * x4,
      x1 * x2 * x3 * x4-1],

    [
        x1+x2+x3+x4+x5+x6,
        x1 * x2+x2 * x3+x3 * x4+x4 * x5+x1 * x6+x5 * x6,
        x1 * x2 * x3+x2 * x3 * x4+x3 * x4 * x5+x1 * x2 * x6+x1 * x5 * x6+x4 * x5 * x6,
        x1 * x2 * x3 * x4+x2 * x3 * x4 * x5+x1 * x2 * x3 * x6+x1 * x2 * x5 * x6+x1 * x4 * x5 * x6+x3 * x4 * x5 * x6,
        x1 * x2 * x3 * x4 * x5+x1 * x2 * x3 * x4 * x6+x1 * x2 * x3 * x5 * x6+x1 * x2 * x4 * x5 * x6+x1 * x3 * x4 * x5 * x6+x2 * x3 * x4 * x5 * x6,
        x1 * x2 * x3 * x4 * x5 * x6-1
    ],

    [
        x1+x2+x3+x4+x5+x6+x7,
        x1 * x2+x2 * x3+x3 * x4+x4 * x5+x5 * x6+x1 * x7+x6 * x7,
        x1 * x2 * x3+x2 * x3 * x4+x3 * x4 * x5+x4 * x5 * x6+x1 * x2 * x7+x1 * x6 * x7+x5 * x6 * x7,
        x1 * x2 * x3 * x4+x2 * x3 * x4 * x5+x3 * x4 * x5 * x6+x1 * x2 * x3 * x7+x1 * x2 * x6 * x7+x1 * x5 * x6 * x7+x4 * x5 * x6 * x7,
        x1 * x2 * x3 * x4 * x5+x2 * x3 * x4 * x5 * x6+x1 * x2 * x3 * x4 * x7+x1 * x2 * x3 * x6 * x7+x1 * x2 * x5 * x6 * x7+x1 * x4 * x5 * x6 * x7+x3 * x4 * x5 * x6 * x7,
        x1 * x2 * x3 * x4 * x5 * x6+x1 * x2 * x3 * x4 * x5 * x7+x1 * x2 * x3 * x4 * x6 * x7+x1 * x2 * x3 * x5 * x6 * x7+x1 * x2 * x4 * x5 * x6 * x7+x1 * x3 * x4 * x5 * x6 * x7+x2 * x3 * x4 * x5 * x6 * x7,
        x1 * x2 * x3 * x4 * x5 * x6 * x7-1
    ],

    [
        x1+x2+x3+x4^2 - 1+x5+x6^2,
        x1 * x2+x2 * x3+x3 * x4^2 - 1+x4^2 - 1 * x5+x1 * x6^2+x5 * x6^2,
        x1 * x2 * x3+x2 * x3 * x4^2 - 1+x3 * x4^2 - 1 * x5+x1 * x2 * x6^2+x1 * x5 * x6^2+x4^2 - 1 * x5 * x6^2,
        x1 * x2 * x3 * x4^2 - 1+x2 * x3 * x4^2 - 1 * x5+x1 * x2 * x3 * x6^2+x1 * x2 * x5 * x6^2+x1 * x4^2 - 1 * x5 * x6^2+x3 * x4^2 - 1 * x5 * x6^2,
        x1 * x2 * x3 * x4^2 - 1 * x5+x1 * x2 * x3 * x4^2 - 1 * x6^2+x1 * x2 * x3 * x5 * x6^2+x1 * x2 * x4^2 - 1 * x5 * x6^2+x1 * x3 * x4^2 - 1 * x5 * x6^2+x2 * x3 * x4^2 - 1 * x5 * x6^2,
        x1 * x2 * x3 * x4^2 - 1 * x5 * x6^2- (x1^4 + x5)
    ],

    [x1] // Placeholder so that the comma always is included.
];
  
  
  

