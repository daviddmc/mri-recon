classdef SensitivityMap < LinearOperator
    
    properties
        map
        ata
    end
    
    methods
        function sm = SensitivityMap(inputList, isAdjoint, map, isNormalized)
            linprop.unitary = isNormalized;
            linprop.shape = -1;
            sm = sm@LinearOperator(linprop, isAdjoint, inputList);
            % Should the map be normalized???
            if isNormalized
                sm.map = map ./ sqrt(sum(abs(map).^2, ndims(map)));
            else
                sm.map = map;
            end
        end
    end
    
    methods(Access = protected)
        y = apply_(sm, x, isCache)
        y = pinv_(sm, x)
        a = AtA_(op, a);
        t = typeAtA_(op, t);
    end
end
            