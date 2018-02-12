function s = shape( op )

if ~isfield(op.props, 'shape')
    if op.isLinear 
        op.props.shape = op.shape_;
        for ii = 1 : length(op.inputList)
            if ~op.inputList{ii}.isConstant
                op.props.shape = sign(op.shape_ + op.inputList{ii}.shape);
                break;
            end
        end
    else
        op.props.shape = 0;
    end
end
s = op.props.shape;

end

