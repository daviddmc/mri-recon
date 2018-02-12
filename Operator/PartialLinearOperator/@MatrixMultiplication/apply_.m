function C = apply_(op, A, B, isCache)

if isCache
    if ~op.inputList{1}.isConstant
        op.cache{1} = A;
    end
    if ~op.inputList{2}.isConstant
        op.cache{2} = B;
    end
end

if nargout > 0
    C = A' * B;
end
    


end

