classdef SensitivityMap < LinearOperator
    
    properties(SetAccess = protected)
        map
    end
    
    methods
        function sm = SensitivityMap(inputList, isAdjoint, map)
            linprop.unitary = 1;
            linprop.shape = -1;
            sm = sm@LinearOperator(linprop, isAdjoint, inputList);
            % Should the map be normalized???
            sm.map = map ./ sqrt(sum(abs(map).^2, ndims(map)));
        end
    end
    
    methods(Access = protected)
        y = apply_(sm, x, isCache)
        y = pinv_(sm, x)
    end
end
            