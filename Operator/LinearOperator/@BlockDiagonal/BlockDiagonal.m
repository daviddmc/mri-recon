classdef BlockDiagonal < LinearOperator

    properties
        AList
        idx
    end
    
    methods
        function bd = BlockDiagonal(inputList, AList, idx)
            %linprop.unitary = 1;
            bd = bd@LinearOperator([], 0, inputList);
            bd.AList = AList;
            if exist('idx', 'var')
                bd.idx = idx;
            end
        end

    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        y = pinv_(rs, x)
    end
    
end

