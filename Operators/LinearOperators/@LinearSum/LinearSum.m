classdef LinearSum < LinearOperator

    properties
        %AList
        signList
    end
    
    methods
        function ls = LinearSum(inputList, isAdjoint, AList, signList)
            if iscell(inputList)
                inputList = [inputList, AList];
            else
                inputList = [{inputList}, AList];
            end
            ls = ls@LinearOperator(inputList, isAdjoint);
            ls.signList = signList;
        end

    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    end
    
end

