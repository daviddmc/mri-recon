classdef LpNorm < Functional
    
    % f(x) = sum(|x_i| ^ p) / p
    
    properties
    end
    
    methods
        function normp = LpNorm(inputList, mu)
            normp = normp@Functional(1, 1, 0, mu, inputList);
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function updateProp_(op);end
    end
    
end
    
   