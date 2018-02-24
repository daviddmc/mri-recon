function y = apply_( ata, x, ~)
A = ata.inList{2};
y = A.adjoint(A.apply(x));



