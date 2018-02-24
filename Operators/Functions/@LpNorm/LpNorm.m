classdef LpNorm < Functional
    
    % f(x) = sum(|x_i| ^ p) / p
    
    properties
        p
    end
    
    methods
        function normp = LpNorm(inputList, mu, p)
            normp = normp@Functional(inputList, mu, 1);
            normp.p = p;
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function p = isGrad_(op)
            p = 1;
        end
        function p = isProx_(op)
            p = 1;
        end
    end
    
end
    
   