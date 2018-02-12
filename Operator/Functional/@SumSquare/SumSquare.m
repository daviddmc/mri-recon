classdef SumSquare < Functional
    
    methods
        function ssd = SumSquare(inputList, mu)
            ssd = ssd@Functional(1, 1, 1, mu, inputList);
            ssd.updateProp_();
        end
        
    end
    
    methods
        z = proxA(ssd, lambda, A, x);
    end
    
    methods(Access = protected)
        y = eval_(ssd, x, isCache)
        
        g = gradOp_(ssd, preGrad)
        
        z = prox_(ssd, lambda, x)
        
        function updateProp_(ssd)
        end
    end
end