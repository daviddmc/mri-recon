function p = isGrad(op)

if ~isfield(op.props, 'isGrad')
    if op.isGrad_ || op.isConstant
        op.props.isGrad = 1;
    else
        op.props.isGrad = 0;
    end

    for ii = 1 : length(op.inputList)
        if ~op.inputList{ii}.isGrad
            op.props.isGrad = 0;
            break
        end
    end
end
p = op.props.isGrad;
end