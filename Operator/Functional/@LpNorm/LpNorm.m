classdef LpNorm < Functional
    
    % f(x) = sum(|x_i| ^ p) / p
    
    properties
        p
    end
    
    methods
        function normp = LpNorm(inputList, mu, p)
            normp = normp@Functional(1, 1, 0, mu, inputList);
            normp.p = p;
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function updateProp_(op);end
    end
    
end
    
   