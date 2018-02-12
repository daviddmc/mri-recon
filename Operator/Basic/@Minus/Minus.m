classdef Minus < Operator
    
    methods
        function op = Minus(inputList)
           op = op@Operator(inputList); 
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
        y = apply_(op, a, b, isCache)
        [ga, gb] = gradOp_(op, preGrad)
    end
    

end