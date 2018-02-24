classdef Identity < LinearOperator
    
    methods
        function Id = Identity(inputList)
            Id = Id@LinearOperator(inputList, 0);
        end
    end
    
    methods(Access = protected)
        y = apply_(Id, x, isCache)
        y = pinv_(Id, x);
        function p = unitary_(op)
            p=1;
        end
    end
    
end