classdef ESPIRiT < LinearOperator
    
    properties(SetAccess = protected)
        eigenVals
        eigenVecs
    end
    
    methods
        function E = ESPIRiT(inputList, isAdjoint, kCalib, kSize, SizeIm, numMap, thK, thIm)
            nc = size(kCalib, 3);
            [k,S] = dat2Kernel(kCalib, kSize);
            idx = find(S >= S(1)*thK, 1, 'last');
            %F = FourierTransformation("ESPIRiT_FT",0, [1, 2]);
            [M,W] = kernelEig(k(:,:,:,1:idx), SizeIm);
            eigenVecs = M(:,:,:,end-numMap+1:end);
            weights = W(:,:,end-numMap+1:end) ;
            weights = (weights - thIm)./(1 - thIm).* (weights > thIm);
            weights = -cos(pi*weights)/2 + 1/2;
            %weights = double(weights > thIm);
            eigenVals = repmat(permute(weights,[1,2,4,3]),[1,1,nc,1]);
            
            E = E@LinearOperator(inputList, isAdjoint);
            
            E.eigenVecs = eigenVecs.*sqrt(eigenVals);
            E.eigenVals = sqrt(eigenVals);
            
        end        
    end
    
    methods(Access = protected)
        y = apply_(S, x, isCache)
        function p = L_(op)
            p = 1;
        end
    end
    
end

