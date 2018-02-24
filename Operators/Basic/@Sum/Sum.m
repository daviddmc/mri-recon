classdef Sum < Operator
    
    properties(SetAccess = protected)
        signList
    end
    
    methods
        function op = Sum(inputList, signList)
           op = op@Operator(inputList, length(inputList));
           op.signList = signList;
        end
    end
    
    methods(Access = protected)
        function p = L_(op)
            p = 1;
        end
        
        function p = isGrad_(op)
            p = 1;
        end
    end
    
    methods(Access = protected)
        y = apply_(op, varargin)
        varargout = gradOp_(op, preGrad)
    end
    

end