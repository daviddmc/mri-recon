function p = isConstant(op)

    if ~isfield(op.props, 'isConstant') || isempty(op.props.isConstant)
        
        p = 1;
     
        for ii = 1 : op.numInput
            if ~op.inList{ii}.isConstant
                p = 0;
                break
            end
        end
        
        op.props.isConstant = p;
        
        if p
            inputs = {};
            for ii = 1 : op.numInput
                inputs{ii} = op.inList{ii}.cache;
            end
            op.cache = op.apply_(inputs{:}, 0);
        else
            %op.cache = [];
        end

    end
    p = op.props.isConstant;
end