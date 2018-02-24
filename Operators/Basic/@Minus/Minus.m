classdef Minus < Operator
    
    methods
        function op = Minus(inputList)
           op = op@Operator(inputList, length(inputList)); 
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
        y = apply_(op, a, b, isCache)
        [ga, gb] = gradOp_(op, preGrad)
    end
    

end