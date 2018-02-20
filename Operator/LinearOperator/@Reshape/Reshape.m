classdef Reshape < LinearOperator
    %RESHAPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sizeIn
        sizeOut
    end
    
    methods
        function rs = Reshape(inputList, sizeIn, sizeOut)
            linprop.unitary = 1;
            rs = rs@LinearOperator(linprop, 0, inputList);
            rs.sizeIn = sizeIn;
            rs.sizeOut = sizeOut;
        end
        
        
        
    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        y = pinv_(rs, x)
        a = AtA_(op, a);
        t = typeAtA_(op, t);
    end
    
end

