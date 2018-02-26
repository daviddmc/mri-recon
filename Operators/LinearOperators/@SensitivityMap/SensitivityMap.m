classdef SensitivityMap < LinearOperator
    
    properties(SetAccess = protected)
        map_
        ata
        isNormalized
    end
    
    properties(Dependent)
        map
    end
    
    methods
        function sm = SensitivityMap(inputList, isAdjoint, map, isNormalized)

            sm = sm@LinearOperator(inputList, isAdjoint);
            % Should the map be normalized???
            sm.isNormalized = isNormalized;
            sm.map = map;
            %if isNormalized
            %    sm.map_ = map ./ sqrt(sum(abs(map).^2, ndims(map)));
            %else
            %    sm.map_ = map;
            %end
            %sm.isNormalized = isNormalized;
        end
        
        function m = get.map(sm)
            m = sm.map_;
        end
        function set.map(sm, map)
            if sm.isNormalized
                sm.map_ = map ./ sqrt(sum(abs(map).^2, ndims(map)));
            else
                sm.map_ = map;
                if isfield(sm.props, 'L') && ~isempty(sm.props.L)
                    sm.props.L = [];
                    sm.broadcast({'L'}, 0);
                end 
                if isfield(sm.props, 'isConstant') && sm.props.isConstant
                    sm.props.isConstant = [];
                    sm.broadcast({'isConstant'}, 0);
                end
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
            