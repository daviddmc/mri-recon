classdef MatrixMultiplication < PartialLinearOperator
    
    methods
        % constructor
        function linOp = MatrixMultiplication(inputList)
            linOp = linOp@PartialLinearOperator(inputList, 2);
        end
    end
    
    methods(Access = protected)
        [gA, gB] = gradOp_(op, preGrad);
        y = apply_(op, a, b, isCache);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
        function p = isLinear_(op)
            p = xor(op.inList{1}.isConstant, op.inList{2}.isConstant);
        end
    end

end