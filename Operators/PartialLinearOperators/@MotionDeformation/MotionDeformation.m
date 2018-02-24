classdef MotionDeformation < PartialLinearOperator
    
    properties(SetAccess = protected)
        interpType
        isAbs
    end
    
    methods
        % constructor
        function D = MotionDeformation(inputList, interpType, isAbs)
            D = D@PartialLinearOperator(inputList, 2);
            D.interpType = interpType;
            D.isAbs = isAbs;
        end
    end
    
    methods(Access = protected)
        
        y = apply_(op, M, I, isCache)
        [dM, dI] = gradOp_(op, preGrad)
        
        function p = isLinear_(op)
            p = op.inList{1}.isConstant && ~op.inList{2}.isConstant;
        end
        
    end

end