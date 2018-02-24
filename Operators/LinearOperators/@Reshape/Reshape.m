classdef Reshape < LinearOperator
    %RESHAPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sizeIn
        sizeOut
    end
    
    methods
        function rs = Reshape(inputList, sizeIn, sizeOut)
            rs = rs@LinearOperator(inputList, 0);
            rs.sizeIn = sizeIn;
            rs.sizeOut = sizeOut;
        end
        
        
        
    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        function p = unitary_(op)
            p = 1;
        end
    end
    
end

