classdef SensitivityMap < LinearOperator
    
    properties(SetAccess = protected)
        map
        ata
        isNormalized
    end
    
    methods
        function sm = SensitivityMap(inputList, isAdjoint, map, isNormalized)

            sm = sm@LinearOperator(inputList, isAdjoint);
            % Should the map be normalized???
            if isNormalized
                sm.map = map ./ sqrt(sum(abs(map).^2, ndims(map)));
            else
                sm.map = map;
            end
            sm.isNormalized = isNormalized;
        end
        
        function setMap(sm, map)
            if sm.isNormalized
                sm.map = map ./ sqrt(sum(abs(map).^2, ndims(map)));
            else
                sm.map = map;
                %if isfield(sm.props, 'L') && ~isempty(sm.props.L)
                %    sm.props.L = [];
                %    sm.broadcast({'L'}, 0);
                %end 
            end
        end
        
    end
    
    methods(Access = protected)
        y = apply_(sm, x, isCache)
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        function p = unitary_(op)
            p = logical(op.isNormalized);
        end
        function p = shapeNotAdjoint(op)
            p = -1;
        end
        
    end
end
            