classdef WaveletTransform < LinearOperator
    
    properties
        qmf
        scale
    end
    
    methods
       
        function wt = WaveletTransform(inputList, isAdjoint, filterType, filterSize, wavScale)
            wt = wt@LinearOperator(inputList, isAdjoint);
            wt.qmf = MakeONFilter(filterType, filterSize);
            wt.scale = wavScale;
        end
        
    end
    
    methods(Access = protected)
        y = apply_(wt, x, isCahce)
        function p = unitary_(op)
            p = 1;
        end
        
    end
    
end