function [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    
    [propChanged, isStructChanged] = receive@Operator(op, pos, propChanged, isStructChanged);
    
    if isempty(pos)
        for ii = 2 : length(op.inList)
            if ~op.inList{ii}.isLinear || op.inList{ii}.isConstant
                error(' ');
            end
        end
    elseif pos > 1
        if ~op.inList{pos}.isLinear || op.inList{pos}.isConstant
            error(' ');
        end
    end
    
end