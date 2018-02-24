function varargout = gradOp_(op, preGrad)

for ii = 1 : op.numInput
    if op.inList{ii}.isConstant
        varargout{ii} = [];
    elseif op.signList(ii) > 0
        varargout{ii} = preGrad;
    else
        varargout{ii} = -preGrad;
    end
end

end

