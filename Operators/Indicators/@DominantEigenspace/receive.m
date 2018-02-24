function [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    
    [propChanged, isStructChanged] = receive@Operator(op, pos, propChanged, isStructChanged);

    if isempty(pos) || pos > 1
        if ~op.inList{2}.isLinear || op.inList{2}.isConstant
            error(' ');
        end
    end
    
end