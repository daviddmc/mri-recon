classdef Weighting < LinearOperator
    
    properties(SetAccess = protected)
        w
    end
    
    methods
        function we = Weighting(inputList, isAdjoint, w)

            we = we@LinearOperator(inputList, isAdjoint);
            we.w = w;
         
        end
        
        function setWeight(op, w)
            op.w = w;
            %if isfield(op.props, 'L') && ~isempty(op.props.L)
            %    sm.props.L = [];
            %    sm.broadcast({'L'}, 0);
            %end 
        end
    end
    
    methods(Access = protected)
        y = apply_(m, x, isCahce)
        y = pinv_(m, x);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        function p = isPinv_(op)
            p = 1;
        end
        
    end
    
end