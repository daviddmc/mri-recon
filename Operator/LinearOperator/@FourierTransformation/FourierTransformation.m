classdef FourierTransformation < LinearOperator
     
    properties(SetAccess = protected)
        dim
    end
    
    methods
        function ft = FourierTransformation(inputList, isAdjoint, dim)
            linprop.unitary = 1;
            ft = ft@LinearOperator(linprop, isAdjoint, inputList);
            if nargin > 0
                ft.dim = dim;
            end
        end
    end
    
    methods(Access = protected)
        y = apply_(ft, x, isCache);
        y = pinv_(ft, x);
        t = typeAtA_(ft, t)
        a = AtA_(ft, a);
    end
        
end