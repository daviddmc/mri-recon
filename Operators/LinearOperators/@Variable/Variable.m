classdef Variable < LinearOperator
    
    properties(SetAccess = protected)
        name = []
    end
    
    methods
        % constructor
        function var = Variable(v)
            var = var@LinearOperator({}, 0, 0);
            if isstring(v)
                var.name = v;
                var.props.isConstant = 0;
                var.varList = {var};
            else
                var.cache = v;
                var.props.isConstant = 1;
                var.varList = {};
            end
            var.topoSort = {var};
        end
        
        setInput(var, v)
    end
    
    methods(Access = protected)
        y = apply_(op, varargin)
        y = gradOp_(op, preGrad)
        y = pinv_(op, x)
        t = typeAtA_(op, t);
        a = AtA_(op, a);
        function p = unitary_(op)
            p = 1;
        end
    end
    
    methods(Static)
        var = getVariable(v)
    end

   
end