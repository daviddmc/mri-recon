classdef Indicator < Functional
    
    methods
        function indicator = Indicator(inputList, numInput)
            indicator = indicator@Functional(inputList, 1, numInput);
            indicator.proxOption.maxIterOuter = 1;
            indicator.proxOption.method = 2;%'POCS';
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, varargin)
        g = gradOp_(fun, preGrad)

        function p = isProx_(op)
            p = 1;
        end
    end
    
end

