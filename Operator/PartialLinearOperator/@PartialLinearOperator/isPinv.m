function p = isPinv(op)

if ~isfield(op.props, 'isPinv')
    if op.isLinear && op.isPinv_
        op.props.isPinv = 1;
        for ii = 1 : length(op.inputList)
            if ~op.inputList{ii}.isConstant && op.inputList{ii}.isPinv
                % <=0 col, >=0 row
                if ~(op.unitary_ && op.shape_ <= 0) && ...
                        ~(op.inputList{ii}.unitary && op.inputList{ii}.shape >=0)
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