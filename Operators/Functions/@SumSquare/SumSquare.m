classdef SumSquare < Functional
    
    methods
        function ssd = SumSquare(inputList, mu)
            ssd = ssd@Functional(inputList, mu, 1);
        end
        
    end
    
    methods(Access = protected)
        y = eval_(ssd, x, isCache)
        
        g = gradOp_(ssd, preGrad)
        
        z = prox_(ssd, lambda, x)
        
        function p = isGrad_(x)
            p = 1;
        end
        function p = funL(x)
            p = 1;
        end
        function p = isProx_(x)
            p = 1;
        end
    end
end