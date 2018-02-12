function p = isProx(op)

    if ~isfield(op.props, 'isProx')
        op.props.isProx = 1;
        jj = 0;
        for ii = 1 : length(op.inputList)
            if ~op.inputList{ii}.isConstant
                jj = jj + 1;
                if ~op.inputList{ii}.isLinear
                    op.props.isProx = 0;
                end
            end
        end
        if jj > 1
            op.props.isProx = 0;
        end
    end
    p = op.props.isProx;
    
end