function p = isProx(op)

    if ~isfield(op.props, 'isProx')
        op.props.isProx = 1;
        for ii = 1 : length(op.inputList)
            if ~op.inputList{ii}.isProx
                op.props.isProx = 0;
                break;
            end
        end
    end
    p = op.props.isProx;
    
end