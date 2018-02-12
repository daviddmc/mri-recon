function type = typeAtA( op )

if op.unitary && op.shape <= 0
    type = 1;
elseif op.unitary_ && op.isLinear
    for ii = 1 : length(op.inputList)
        if ~op.inputList{ii}.isConstant
            type = op.inputList{ii}.typeAtA;
            break
        end
    end
else
    type = 0;
end

end

