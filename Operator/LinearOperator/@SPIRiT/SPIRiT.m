classdef SPIRiT < LinearOperator
    
    properties(SetAccess = protected)
        map
        type
        F
        isMinusI
    end
    
    methods
        function S = SPIRiT(inputList, isAdjoint, kCalib, kSize, CalibTyk, type, SizeIm, isMinusI)
            nc = size(kCalib, 3);
            [AtA] = dat2AtA(kCalib,kSize);
            for n = nc : -1 : 1
                kernel(:,:,:,n) = calibrate(AtA, kSize, nc, n, CalibTyk);
            end
            
            F = FourierTransformation("SPIRiT_FT",0, [1, 2]);
            
            for n = size(kernel,4):-1:1
                fac = sqrt(SizeIm(1) * SizeIm(2));
                sizePadded = [SizeIm(1), SizeIm(2)];
                map(:,:,:,n) = F.adjoint(padCenter(kernel(end:-1:1,end:-1:1,:,n) * fac, sizePadded));
            end
            m = sqrt(sum(abs(map).^2,  4));
            
            linprop.l2norm = logical(isMinusI) + sqrt(nc)*max(m(:));
            S = S@LinearOperator(linprop, isAdjoint, inputList);
            
            S.F = F;
            S.map = map;
            S.type = type;
            S.isMinusI = isMinusI;
            
        end        
    end
    
    methods(Access = protected)
        y = apply_(S, x, isCache)
    end
    
end

