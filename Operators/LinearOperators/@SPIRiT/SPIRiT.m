classdef SPIRiT < LinearOperator
    
    properties(SetAccess = protected)
        map
        type
        %F
        isMinusI
    end
    
    methods
        function S = SPIRiT(inputList, isAdjoint, kCalib, kSize, CalibTyk, type, SizeIm, isMinusI)
            nc = size(kCalib, 3);
            [AtA] = calibmat(kCalib,kSize);
            for n = nc : -1 : 1
                kernel(:,:,:,n) = calibrate(AtA, kSize, nc, n, CalibTyk);
            end
            
            %F = FourierTransformation("SPIRiT_FT",0, [1, 2]);
            
            for n = size(kernel,4):-1:1
                fac = sqrt(SizeIm(1) * SizeIm(2));
                sizePadded = [SizeIm(1), SizeIm(2)];
                map(:,:,:,n) = ifftc(zpadc(kernel(end:-1:1,end:-1:1,:,n) * fac, sizePadded), [1,2]);
            end
            m = sqrt(sum(abs(map).^2,  4));
            
            S = S@LinearOperator(inputList, isAdjoint);
            
            %S.F = F;
            S.map = map;
            S.type = type;
            S.isMinusI = isMinusI;
            
        end        
    end
    
    methods(Access = protected)
        y = apply_(S, x, isCache)
        
        function p = L_(op)
            if op.isMinusI
                p = 4;
            else
                p = 1;
            end
        end
    end
    
end

