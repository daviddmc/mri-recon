function p = L(op)
    if ~isfield(op.props, 'L') || isempty(op.props.L)
        maxL = 0;
        op.props.L = 1;
        for ii = 1 : op.numInput
            if op.inList{ii}.isLinear
                l = op.inList{ii}.L;
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