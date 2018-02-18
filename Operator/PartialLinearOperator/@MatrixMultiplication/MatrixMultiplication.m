classdef MatrixMultiplication < PartialLinearOperator
    
    properties(SetAccess = protected)
       
    end
    
    methods
        % constructor
        function linOp = MatrixMultiplication(inputList)
            inputList = parseInputList(inputList);
            isLinear = inputList{1}.isConstant || inputList{2}.isConstant;
            linOp = linOp@PartialLinearOperator(isLinear, [], inputList);
        end
    end
    
    methods(Access = protected)
        function updateProp_(op)
            op.isLinear_ = op.inputList{1}.isConstant || op.inputList{2}.isConstant;
        end
        [gA, gB] = gradOp_(op, preGrad);
        y = apply_(op, a, b, isCache);
        a = AtA_(op, a);
        t = typeAtA_(op, t);
    end

end