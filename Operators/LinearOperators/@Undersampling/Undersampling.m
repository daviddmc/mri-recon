classdef Undersampling < LinearOperator
    
    properties(SetAccess = protected)
        mask = []
        idx = []
        sizeMask = []
        isReduced = 0;
    end
    
    methods
        function m = Undersampling(inputList, isAdjoint, mask, isReduced)
            m = m@LinearOperator(inputList, isAdjoint);
            m.isReduced = isReduced;
            if isReduced
                m.idx = find(mask);
                m.sizeMask = size(mask);
            else
                m.mask = mask;
            end
        end
    end
    
    methods(Access = protected)
        y = apply_(m, x, isCahce)
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        function p = unitary_(op)
            p = 1;
        end
        function p = shapeNotAdjoint(op)
            p = 1;
        end
        
    end
    
end