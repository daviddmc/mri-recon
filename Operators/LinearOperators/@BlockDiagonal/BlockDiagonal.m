classdef BlockDiagonal < LinearOperator

    properties
        %AList
        idx
    end
    
    methods
        function bd = BlockDiagonal(inputList, AList, idx)
            if iscell(inputList)
                inputList = [inputList, AList];
            else
                inputList = [{inputList}, AList];
            end
            bd = bd@LinearOperator(inputList, 0);
            if nargin == 3
                bd.idx = idx;
            end
        end
    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
        %y = pinv_(rs, x)
    end
    
end

