classdef PartialLinearOperator < Operator
    
    properties(SetAccess = protected)
        unitary_
        isPinv_
        shape_
    end
    
    methods
        % constructor
        function linOp = PartialLinearOperator(isLinear, linProp, inputList)
            linOp = linOp@Operator(inputList);
            linOp.isGrad_ = 1;
            linOp.updateProp(isLinear, linProp);
        end
        
        y = adjoint(op, x)
        y = pinv(op, x)
        
        p = isPinv(op)
        u = unitary(op)
        s = shape(op)
        
        t = typeAtA(op, t);
        a = AtA(op);
            
    end
    
    methods(Access = protected)
        t = typeAtA_(op, t)
        a = AtA_(op, a);
        updateProp(linOp, isLinear, linProp);
        function y = pinv_(op, x)
            error(' ');
        end
    end
    
    methods(Access = protected, Abstract)
        updateProp_(op)
    end

end