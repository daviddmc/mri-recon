classdef Undersampling < LinearOperator
    
    properties
        mask = []
        idx = []
        sizeMask = []
        isReduced = 0;
    end
    
    methods
        function m = Undersampling(inputList, isAdjoint, mask, isReduced)
            linprop.unitary = 1;
            linprop.shape = 1;
            m = m@LinearOperator(linprop, isAdjoint, inputList);
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
        y = pinv_(m, x);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
    end
    
end