function [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
            
    if isStructChanged
        for ii = 1 : op.numInput
            if isa(op.inList{ii}, 'Functional')
                error(' ');
            end
        end
    end

    [propChanged, isStructChanged] = receive@Operator(op, pos, propChanged, isStructChanged);
end