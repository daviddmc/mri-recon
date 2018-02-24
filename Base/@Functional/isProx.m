function p = isProx(op)

    if ~isfield(op.props, 'isProx') || isempty(op.props.isProx)
        op.props.isProx = 1;
        jj = 0;
        for ii = 1 : op.numInput
            if ~op.inList{ii}.isConstant
                jj = jj + 1;
                if ~op.inList{ii}.isLinear
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