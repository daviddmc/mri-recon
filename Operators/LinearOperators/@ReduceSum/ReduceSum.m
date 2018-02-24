classdef ReduceSum < LinearOperator
    
    properties
        dim
        len
        isNormalized
    end
    
    methods
        function s = ReduceSum(inputList, isAdjoint, dim, len, isNormalized)            

            s = s@LinearOperator(inputList, isAdjoint);
            s.dim = dim;
            s.len = len;
            s.isNormalized = isNormalized;
        end
    end
    
    methods(Access = protected)
        y = apply_(s, x, isCache)
        y = pinv_(s, x);
        function p =  unitary_(op)
            p = ifelse(op.isNormalized, 1, op.len);
        end
        function p = shapeNotAdjoint(op)
            p = op.len > 1;
        end
    end
    
end