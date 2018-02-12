classdef MotionDeformation < PartialLinearOperator
    
    properties(SetAccess = protected)
        interpType
        isAbs
    end
    
    methods
        % constructor
        function D = MotionDeformation(inputList, interpType, isAbs)
            inputList = parseInputList(inputList);
            isLinear_ = inputList{1}.isConstant;
            D = D@PartialLinearOperator(isLinear_, [], inputList);
            D.interpType = interpType;
            D.isAbs = isAbs;
        end
    end
    
    methods(Access = protected)
        
        function updateProp_(op)
            op.isLinear_ = op.inputList{1}.isConstant;
        end
        
        y = apply_(op, M, I, isCache)
        [dM, dI] = gradOp_(op, preGrad)
        y = pinv_(op, x);
        y = JacOp_(op, x);
    end

end