classdef Gradient < LinearOperator

    properties
        dim
        weight
        sizeX
        AtAeig
    end
    
    methods
        function g = Gradient(inputList, isAdjoint, dim, weight)
            if ~exist('weight','var') || isempty(weight)
                weight = [];
                weightMax = 1;
            else
                weightMax = abs(max(weight));
            end
            if length(dim) > 1
                linprop.shape = -1;
            end
            linprop.l2norm = sqrt(length(dim)) * 2 * weightMax;
            g = g@LinearOperator(linprop, isAdjoint, inputList);
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
    end
end
