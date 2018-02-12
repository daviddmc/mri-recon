classdef LinearOperator < PartialLinearOperator
    
    properties(SetAccess = protected)        
        isAdjoint
    end
    
    methods
        % constructor
        function linOp = LinearOperator(linprop, isAdjoint, inputList)
            if isAdjoint
                if isfield(linprop, 'shape')
                    linprop.shape = -linprop.shape;
                end
            end
            linOp = linOp@PartialLinearOperator(1, linprop, inputList);
            linOp.isAdjoint = isAdjoint;
        end
        
    end
    
    methods(Access = protected)
        updateProp_(linOp);
        y = JacOp_(op, x)
        y = gradOp_(op, preGrad)
    end

end