classdef FourierTransform < LinearOperator
%FourierTransform   Discrete Fourier transform
    properties(SetAccess = protected)
        dim
    end
    
    methods
        function ft = FourierTransform(inputList, isAdjoint, dim)
            ft = ft@LinearOperator(inputList, isAdjoint);
            ft.dim = dim;
        end
    end
    
    methods(Access = protected)
        y = apply_(ft, x, isCache);
        t = typeAtA_(ft, t)
        a = AtA_(ft, a);
        function p = unitary_(op)
            p = 1;
        end
    end
        
end