classdef Hankel < LinearOperator
    
    properties
        sizeIn
        sizeOut
        sizeKernel
    end
    
    methods
        function h = Hankel(inputList, isAdjoint, sizeIn, sizeKernel)
            linprop.shape = -1;
            linprop.isPinv = 1;
            linprop.l2norm = sqrt(sizeKernel(1) * sizeKernel(2));
            h = h@LinearOperator(linprop, isAdjoint, inputList);
            h.sizeIn = sizeIn;
            h.sizeKernel = sizeKernel;
            h.sizeOut = [prod(sizeIn(1:2) - sizeKernel + 1), prod(sizeKernel), prod(sizeIn(3:end))];
        end
        a = AtA(op);
        t = typeAtA(op);
    end
    
    methods(Access = protected)
        y = apply_(h, x, isCahce)
        y = pinv_(h, x);
    end
    
end