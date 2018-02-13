classdef ZeroFunction < Functional
    
    methods
        function zf = ZeroFunction(inputList)
            zf = zf@Functional(1, 1, 0, 0, inputList);
        end
    end
    
    methods(Access = protected)
        y = eval_(ssd, x, isCache)
        
        g = gradOp_(ssd, preGrad)
        
        z = prox_(ssd, lambda, x)
        
        function updateProp_(ssd)
        end
    end
    
end
    
   