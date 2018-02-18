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
        
        
    end
    
    methods(Access = protected)
        y = apply_(m, x, isCahce)
        y = pinv_(m, x);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
    end
    
end