classdef ZeroPad < LinearOperator
    
    properties(Access = protected)
        sizeFull
        sizeCenter
    end
    
    methods
        function zp = ZeroPad(inputList, isAdjoint, sizeFull, sizeCenter)
            zp = zp@LinearOperator(inputList, isAdjoint);
            zp.sizeFull = sizeFull;
            zp.sizeCenter = sizeCenter;
        end
    end
    
    methods(Access = protected)
        y = apply_(zp, x, isCache)
        function p = unitary_(op)
            p = 1;
        end
        function p = shapeNotAdjoint(op)
            p = -1;
        end
    end
    
end
    
    
    
            
            