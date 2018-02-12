classdef Indicator < Functional
    
    properties
    end
    
    methods
        function indicator = Indicator(inputList)
            indicator = indicator@Functional(1, 0, 0, 1, inputList);
            indicator.proxOption.maxIter = 1;
            indicator.proxOption.method = 2;%'POCS';
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, varargin)
        g = gradOp_(fun, preGrad)
        %z = proxA(ssd, lambda, A, x)
        function updateProp_(op);end
    end
    
end

