classdef LinearEquation < Indicator
    
    methods
        function lineq = LinearEquation(inputList)
            lineq = lineq@Indicator(inputList);
        end
    end
    
    methods(Access = protected)
        z = prox_(lineq, lambda, x, y)
    end
    
end

