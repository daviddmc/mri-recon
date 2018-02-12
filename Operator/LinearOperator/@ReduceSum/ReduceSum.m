classdef ReduceSum < LinearOperator
    
    properties
        dim
        len
        isNormalized
    end
    
    methods
        function s = ReduceSum(inputList, isAdjoint, dim, len, isNormalized)            
            if isNormalized
                linprop.unitary = 1;
            else
                linprop.unitary = len;
            end
            
            if len > 1
                linprop.shape = 1;
            end
                
            s = s@LinearOperator(linprop, isAdjoint, inputList);
            s.dim = dim;
            s.len = len;
            s.isNormalized = isNormalized;
        end
    end
    
    methods(Access = protected)
        y = apply_(s, x, isCache)
        y = pinv_(s, x);
    end
    
end