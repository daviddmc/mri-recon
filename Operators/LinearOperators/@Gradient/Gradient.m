classdef Gradient < LinearOperator

    properties
        dim
        weight
        sizeX
        AtAeig
    end
    
    methods
        function g = Gradient(inputList, isAdjoint, dim, weight)
            if nargin < 4
                weight = [];
            end
            g = g@LinearOperator(inputList, isAdjoint);
            if(length(dim) ~= length(unique(dim)))
                error(' ');
            end
            g.dim = dim;
            g.weight = weight;
        end
    end
    
    methods(Access = protected)
        y = apply_(g, x, isCache)
        t = typeAtA_(op, t)
        a = AtA_(op, a);
        function p = shapeNotAdjoint(op)
            p = -(length(op.dim)>1);
        end
        function p = L_(op)
            if isempty(op.weight)
                wm = 1;
            else
                wm = abs(max(op.weight));
            end
            p = length(op.dim) * 4 * wm^2;
        end
    end
end
