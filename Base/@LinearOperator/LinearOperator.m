classdef LinearOperator < PartialLinearOperator
    
    properties(SetAccess = protected)        
        isAdjoint
    end
    
    methods
        % constructor
        function linOp = LinearOperator(inputList, isAdjoint, numInput)
            if nargin < 3
                numInput = 1;
            end
            linOp = linOp@PartialLinearOperator(inputList, numInput);
            linOp.isAdjoint = isAdjoint;
        end

    end
    
    methods(Access = protected)
        y = gradOp_(op, preGrad)
        function p = isLinear_(op)
            p = 1;
        end
        function p = shapeNotAdjoint(op)
            p = 0;
        end
    end
    
    methods(Access = protected, Sealed)
        function p = shape_(op)
            if op.isAdjoint
                p = -op.shapeNotAdjoint;
            else
                p = op.shapeNotAdjoint;
            end
        end
    end

end