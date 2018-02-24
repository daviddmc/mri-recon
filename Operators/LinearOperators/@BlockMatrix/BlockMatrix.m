classdef BlockMatrix< LinearOperator

    properties
        %AList
        isRow
        dim
        idx
    end
    
    methods
        function bm = BlockMatrix(inputList, AList, isRow, dim, idx)
            if iscell(inputList)
                inputList = [inputList, AList];
            else
                inputList = [{inputList}, AList];
            end
            bm = bm@LinearOperator(inputList, 0);
            bm.isRow = isRow;
            bm.dim = dim;
            if nargin == 5
                bm.idx = idx;
            end
        end
    end
    
    methods(Access=protected)
        y = apply_(rs, x, isCache)
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    end
    
end

