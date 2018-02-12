classdef WaveletTransformation < LinearOperator
    
    properties
        qmf
        scale
    end
    
    methods
       
        function wt = WaveletTransformation(inputList, isAdjoint, filterType, filterSize, wavScale)
            linprop.unitary = 1;
            wt = wt@LinearOperator(linprop, isAdjoint, inputList);
            wt.qmf = MakeONFilter(filterType, filterSize);
            wt.scale = wavScale;
        end
        
    end
    
    methods(Access = protected)
        y = apply_(wt, x, isCahce)
        y = pinv_(wt, x)
    end
    
end