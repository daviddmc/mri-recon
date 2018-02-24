function p = isPinv(op)

if ~isfield(op.props, 'isPinv') || isempty(op.props.isPinv)
    if op.isLinear && op.isPinv_
        op.props.isPinv = 1;
        for ii = 1 : op.numInput
            if ~op.inList{ii}.isConstant && op.inList{ii}.isPinv
                % <=0 col, >=0 row
                if ~(op.unitary_ && op.shape_ <= 0) && ...
                        ~(op.inList{ii}.unitary && op.inList{ii}.shape >=0)
                    op.props.isPinv = 0;
                end
                break
            end
        end
    else
        op.props.isPinv = 0;
    end
end
p = op.props.isPinv;
end