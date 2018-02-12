function p = isLinear(op)

    if ~isfield(op.props, 'isLinear')
        
        if op.isLinear_ || op.isConstant
            op.props.isLinear = 1;
        else
            op.props.isLinear = 0;
        end

        for ii = 1 : length(op.inputList)
            if ~op.inputList{ii}.isLinear
                op.props.isLinear = 0;
            end
        end

    end
    p = op.props.isLinear;
end