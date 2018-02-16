classdef L12Norm < Functional
    
    properties
        dim2;
    end
    
    methods
        function norm12 = L12Norm(inputList, mu, dim2)
            norm12 = norm12@Functional(1, 1, 0, mu, inputList);
            norm12.dim2 = dim2;
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function updateProp_(op);end
    end
    
end
    
   