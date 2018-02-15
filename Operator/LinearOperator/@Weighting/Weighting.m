classdef Weighting < LinearOperator
    
    properties
        w
    end
    
    methods
        function we = Weighting(inputList, isAdjoint, w)
            linprop.isPinv = 1;
            we = we@LinearOperator(linprop, isAdjoint, inputList);
            we.w = w;
            
        end
        
        a = AtA(op);
        t = typeAtA(op);
    end
    
    methods(Access = protected)
        y = apply_(m, x, isCahce)
        y = pinv_(m, x);
    end
    
end