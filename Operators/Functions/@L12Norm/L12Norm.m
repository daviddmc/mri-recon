classdef L12Norm < Functional
    
    properties
        dim2;
    end
    
    methods
        function norm12 = L12Norm(inputList, mu, dim2)
            norm12 = norm12@Functional(inputList, mu, 1);
            norm12.dim2 = dim2;
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
    
   