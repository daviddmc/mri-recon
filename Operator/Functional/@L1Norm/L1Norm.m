classdef L1Norm < Functional
    
    properties
    end
    
    methods
        function norm1 = L1Norm(inputList, mu)
            norm1 = norm1@Functional(1, 1, 0, mu, inputList);
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function updateProp_(op);end
    end
    
end
    
   