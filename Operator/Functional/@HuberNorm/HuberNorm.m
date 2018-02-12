classdef HuberNorm < Functional
    
    properties
        omega
    end
    
    methods
        function normh = HuberNorm(inputList, mu, omega)
            normh = normh@Functional(1, 1, 1/omega, mu, inputList);
            normh.omega = omega;
        end
    end
    
    methods(Access=protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
        function updateProp_(op);end
    end
    
end
    
   