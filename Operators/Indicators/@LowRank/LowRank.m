classdef LowRank < Indicator
    
    properties
        r
    end
    
    methods
        function lr = LowRank(inputList, r)
            lr = lr@Indicator(inputList, 1);
            lr.r = r;
        end
    end
    
    methods(Access = protected)
        z = prox_(lineq, lambda, x)
    end
    
end

