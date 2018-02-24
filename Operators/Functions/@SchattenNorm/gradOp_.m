function g = gradOp_( nuc, preGrad)

u = nuc.cache{1};
s = nuc.cache{2};
v = nuc.cache{3};

s = s.^(nuc.p - 1) * preGrad;
s(~isfinite(s)) = 0;

g = u * bsxfun(@times, s, v'); 

end

