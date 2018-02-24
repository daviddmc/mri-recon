function [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    
    [propChanged, isStructChanged] = receive@Operator(op, pos, propChanged, isStructChanged);

    if isempty(pos)
        for ii = 2 : length(op.inList)
            if ~isa(op.inList{ii}, 'Functional') || ...
                    op.inList{ii}.isConstant || ...
                    op.inList{ii}.numInput ~= 1
                error(' ');
            end
        end
    elseif pos > 1
        if ~isa(op.inList{pos}, 'Functional') || ...
                op.inList{pos}.isConstant || ...
                op.inList{pos}.numInput ~= 1
            error(' ');
        end
    end
end