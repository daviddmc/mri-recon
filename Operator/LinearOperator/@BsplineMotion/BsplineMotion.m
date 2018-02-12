classdef BsplineMotion < LinearOperator
     
    properties(SetAccess = protected)
        is3D
        coef
        sizeNode
        spacing
    end
    
    methods
        function bm = BsplineMotion(inputList, isAdjoint, is3D, spacing, sizeNode)
            if strcmpi(is3D, '3d')
                is3D = 1;
            else
                is3D = 0;
            end
            coef = BsplineCoef(spacing, is3D);
            if spacing > 1
                linprop.shape = -1;
            else
                linprop = [];
            end
            bm = bm@LinearOperator(linprop, isAdjoint, inputList);
            bm.coef = coef;
            bm.is3D = is3D;
            bm.sizeNode = sizeNode;
            bm.spacing = spacing;
        end
    end
    
    methods(Access = protected)
        y = apply_(bm, x, isCache);
    end
        
end