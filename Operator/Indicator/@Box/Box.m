classdef Box < Indicator
    
    properties
        low
        high
        flagLow
        flagHigh
    end
    
    methods
        function b = Box(inputList, low, high)
            b = b@Indicator(inputList);
            b.low = low;
            b.high = high;
            
            if isempty(low)
                b.flagLow = 0;
            elseif length(low) == 1
                b.flagLow = 1;
            else
                b.flagLow = 2;
            end
            
            if isempty(high)
                b.flagHigh = 0;
            elseif length(high) == 1
                b.flagHigh = 1;
            else
                b.flagHigh = 2;
            end
                
        end
        
        z = prox_(b, lambda, x)
    end
    
end

