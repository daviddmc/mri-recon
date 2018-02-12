function u = unitary(op)
    if ~isfield(op.props, 'unitary')
        if op.isLinear && op.unitary_
            op.props.unitary = 1;
            for ii = 1 : length(op.inputList)
                if ~op.inputList{ii}.isConstant
                    if op.inputList{ii}.shape * op.shape_ < 0
                        op.props.unitary = 0;
                    else
                        op.props.unitary = op.inputList{ii}.unitary * op.unitary_;
                    end
                    break
                end
            end
        else
            op.props.unitary = 0;
        end
    end
    u = op.props.unitary;
end