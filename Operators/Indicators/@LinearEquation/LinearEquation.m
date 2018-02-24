classdef LinearEquation < Indicator
    
    methods
        function lineq = LinearEquation(inputList)
            lineq = lineq@Indicator(inputList, 2);
        end
    end
    
    methods(Access = protected)
        z = prox_(lineq, lambda, x, y)
        
        function p = isProx_(op)
            p = xor(op.inList{1}.isConstant, op.inList{2}.isConstant);
        end
    end
    
end

