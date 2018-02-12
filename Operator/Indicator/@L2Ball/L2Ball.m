classdef L2Ball < Indicator
    
    properties
        r
    end
    
    methods
        function ball = L2Ball(inputList, r)
            ball = ball@Indicator(inputList);
            ball.r = r;
        end
        
        z = prox_(ball, lambda, x)
    end
    
end

