classdef Identity < LinearOperator
    
    properties
    end
    
    methods
        function Id = Identity(inputList)
            linprop.unitary = 1;
            Id = Id@LinearOperator(linprop, 0, inputList);
        end
    end
    
    methods(Access = protected)
        y = apply_(Id, x, isCache)
        y = pinv_(Id, x);
    end
    
end