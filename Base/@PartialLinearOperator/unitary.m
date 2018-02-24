function u = unitary(op)
    if ~isfield(op.props, 'unitary') || isempty(op.props.unitary)
        if op.isLinear && op.unitary_
            op.props.unitary = 1;
            for ii = 1 : op.numInput
                if ~op.inList{ii}.isConstant
                    if op.inList{ii}.shape * op.shape_ < 0
                        op.props.unitary = 0;
                    else
                        op.props.unitary = op.inList{ii}.unitary * op.unitary_;
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