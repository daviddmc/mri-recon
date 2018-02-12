function updateProp(op, isLinear, linProp)

if nargin > 1
    op.isLinear_ = isLinear;
    if isLinear
        
        if isempty(linProp)
            linProp = struct();
        end
        
        if isfield(linProp, 'unitary')
            op.unitary_ = linProp.unitary;
        else
            op.unitary_ = 0;
        end

        if isfield(linProp, 'shape')
            op.shape_ = linProp.shape;
        else
            op.shape_ = 0;
        end
        
        if isfield(linProp, 'isPinv')
            op.isPinv_ = linProp.isPinv;
        else
            op.isPinv_ = logical(op.unitary_);
        end

        if isfield(linProp, 'l2norm')
            op.L_ = linProp.l2norm^2;
        else
            op.L_ = op.unitary_;
        end
    end
else
    op.updateProp_()
end

for ii = 1 : length(op.inputList)
    if isa(op.inputList{ii}, 'Functional')
        error(' ');
    end
end



end

