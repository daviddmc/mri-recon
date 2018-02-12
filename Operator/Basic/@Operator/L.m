function p = L(op)
    if ~isfield(op.props, 'L')
        maxL = 0;
        op.props.L = 1;
        for ii = 1 : length(op.inputList)
            if op.inputList{ii}.isLinear
                l = op.inputList{ii}.L;
                if l > maxL
                    maxL = l;
                    op.props.L = op.L_ * maxL;
                end
            else
                op.props.L = 0;
                break;
            end
        end
    end
    p = op.props.L;
end