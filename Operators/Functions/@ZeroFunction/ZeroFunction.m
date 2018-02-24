classdef ZeroFunction < Functional
    
    methods
        function zf = ZeroFunction(inputList)
            zf = zf@Functional(inputList, 1, 1);
        end
    end
    
    methods(Access = protected)
        y = eval_(ssd, x, isCache)
        
        g = gradOp_(ssd, preGrad)
        
        z = prox_(ssd, lambda, x)
    end
    
end
    
   