classdef Hankel < LinearOperator
    
    properties
        sizeIn
        sizeOut
        sizeKernel
    end
    
    methods
        function h = Hankel(inputList, isAdjoint, sizeIn, sizeKernel)
            h = h@LinearOperator(inputList, isAdjoint);
            h.sizeIn = sizeIn;
            h.sizeKernel = sizeKernel;
            h.sizeOut = [prod(sizeIn(1:2) - sizeKernel + 1), prod(sizeKernel), prod(sizeIn(3:end))];
        end
        
    end
    
    methods(Access = protected)
        y = apply_(h, x, isCahce)
        y = pinv_(h, x);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        function p = shapeNotAdjoint(op)
            p = -1;
        end
        function p = L_(op)
            p = sqrt(prod(op.sizeKernel));
        end
        function p = isPinv_(op)
            p = 1;
        end
    end
    
end