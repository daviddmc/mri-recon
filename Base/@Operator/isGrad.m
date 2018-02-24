function p = isGrad(op)

if ~isfield(op.props, 'isGrad') || isempty(op.props.isGrad)
    if op.isGrad_
        op.props.isGrad = 1;
    else
        op.props.isGrad = 0;
    end

    for ii = 1 : op.numInput
        if ~op.inList{ii}.isGrad && ~op.inList{ii}.isConstant
            op.props.isGrad = 0;
            break
        end
    end
end
p = op.props.isGrad;
end