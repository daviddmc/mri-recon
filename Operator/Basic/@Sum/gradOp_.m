function varargout = gradOp_(op, preGrad)

for ii = 1 : length(op.inputList)
    if op.inputList{ii}.isConstant
        varargout{ii} = [];
    elseif op.signList(ii) > 0
        varargout{ii} = preGrad;
    else
        varargout{ii} = -preGrad;
    end
end

end

