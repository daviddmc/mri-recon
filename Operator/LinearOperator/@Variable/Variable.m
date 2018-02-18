classdef Variable < LinearOperator
    
    properties(SetAccess = protected)
        name = []
    end
    
    methods
        % constructor
        function var = Variable(v)
            linprop.unitary = 1;
            var = var@LinearOperator(linprop, 0, {});
            var.varList = {var};
            if isstring(v)
                var.name = v;
                var.isConstant = 0;
            else
                var.cache = v;
                var.isConstant = 1;
                var.varList = {};
            end
        end
        
        setVar(var, v)
    end
    
    methods(Access = protected)
        y = apply_(op, varargin)
        y = gradOp_(op, preGrad)
        y = pinv_(op, x)
        t = typeAtA_(op, t);
        a = AtA_(op, a);
    end
    
    methods(Static)
        var = getVariable(v)
    end

   
end