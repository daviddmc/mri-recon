classdef LinearSum < LinearOperator

    properties
        AList
        signList
    end
    
    methods
        function ls = LinearSum(inputList, isAdjoint, AList, signList)
            ls = ls@LinearOperator([], isAdjoint, inputList);
            ls.AList = AList;
            ls.signList = signList;
        end

    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        %y = pinv_(rs, x)
    end
    
end

