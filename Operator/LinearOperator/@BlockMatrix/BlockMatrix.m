classdef BlockMatrix< LinearOperator

    properties
        AList
        isRow
        dim
        idx
    end
    
    methods
        function bm = BlockMatrix(inputList, AList, isRow, dim, idx)
            %linprop.unitary = 1;
            bm = bm@LinearOperator([], 0, inputList);
            bm.AList = AList;
            bm.isRow = isRow;
            bm.dim = dim;
            if exist('idx', 'var')
                bm.idx = idx;
            end
        end
    end
    
    methods(Access=protected)
        y = apply_(rs, x, isCache)
        y = pinv_(rs, x)
    end
    
end

