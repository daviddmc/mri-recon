function y = apply_( ata, x, ~)

y = ata.A.adjoint(ata.A.apply(x));



