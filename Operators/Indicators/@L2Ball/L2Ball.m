classdef L2Ball < Indicator
    
    properties
        r
    end
    
    methods
        function ball = L2Ball(inputList, r)
            ball = ball@Indicator(inputList, 1);
            ball.r = r;
        end
    end
        
    
    methods(Access = protected)
        z = prox_(ball, lambda, x)
    end
    
end

