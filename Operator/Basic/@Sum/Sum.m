classdef Sum < Operator
    
    properties(SetAccess = protected)
        signList
    end
    
    methods
        function op = Sum(inputList, signList)
           op = op@Operator(inputList);
           op.updateProp();
           op.signList = signList;
        end
    end
    
    methods(Access = protected)
        function updateProp(op)
            op.L_ = 1;
            op.isLinear_ = 0;
            op.isGrad_ = 1;
        end
    end
    
    methods(Access = protected)
        y = apply_(op, varargin)
        varargout = gradOp_(op, preGrad)
    end
    

end