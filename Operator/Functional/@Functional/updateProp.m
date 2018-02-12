function updateProp(op, isProx, isGrad, L)

if nargin > 1
    op.isProx_ = isProx;
    op.isGrad_ = isGrad;
    op.L_ = L;
else
    op.updateProp_();
end

for ii = 1 : length(op.inputList)
    if isa(op.inputList{ii}, 'Functional')
        error(' ');
    end
end

end

