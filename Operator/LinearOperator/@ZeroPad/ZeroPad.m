classdef ZeroPad < LinearOperator
    
    properties(Access = protected)
        sizeFull
        sizeCenter
    end
    
    methods
        function zp = ZeroPad(inputList, isAdjoint, sizeFull, sizeCenter)
            linprop.unitary = 1;
            linprop.shape = -1;
            zp = zp@LinearOperator(linprop, isAdjoint, inputList);
            zp.sizeFull = sizeFull;
            zp.sizeCenter = sizeCenter;
        end
    end
    
    methods(Access = protected)
        y = apply_(zp, x, isCache)
        y = pinv_(zp, x)
    end
    
end
    
    
    
            
            