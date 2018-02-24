classdef HuberNorm < Functional
    
    properties
        omega
    end
    
    methods
        function normh = HuberNorm(inputList, mu, omega)
            normh = normh@Functional(inputList, mu, 1);
            normh.omega = omega;
        end
    end
    
    methods(Access=protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function p = isGrad_(op)
            p = 1;
        end
        function p = funL(op)
            p = 1/normh.omega;
        end
        function p = isProx_(op)
            p = 1;
        end
    end
    
end
    
   