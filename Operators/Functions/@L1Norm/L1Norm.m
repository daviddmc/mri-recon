classdef L1Norm < Functional
    
    methods
        function norm1 = L1Norm(inputList, mu)
            norm1 = norm1@Functional(inputList, mu, 1);
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function p = isProx_(op)
            p = 1;
        end
        function p = isGrad_(op)
            p = 1;
        end
    end
    
end
    
   