classdef ZeroFunction < Functional
    
    properties
    end
    
    methods
        function zf = ZeroFunction(inputList, mu)
            zf = zf@Functional(1, 1, 1, mu, inputList);% TODO; L should be 0
        end
        
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, preGrad)
      
    end
    
end
    
   