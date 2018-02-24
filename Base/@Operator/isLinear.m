function p = isLinear(op)

    if ~isfield(op.props, 'isLinear') || isempty(op.props.isLinear)
        if op.isLinear_
            op.props.isLinear = 1;
        else
            op.props.isLinear = 0;
        end
        jj = 0;
        for ii = 1 : op.numInput
            if ~op.inList{ii}.isConstant
                jj = jj + 1;
                if ~op.inList{ii}.isLinear
                    op.props.isLinear = 0;
                end
            end
        end
        if jj > 1
            op.props.isLinear = 0;
        end
    end
    p = op.props.isLinear;
end