classdef SumSquaredDifference < Functional
    
    methods
        function ssd = SumSquaredDifference(inputList, mu)
            ssd = ssd@Functional(inputList, mu, 2);
        end
        
    end
    
    methods(Access = protected)
        y = eval_(ssd, x1, x2, isCache)
        
        [g1, g2] = gradOp_(ssd, preGrad)
        
        z = prox_(ssd, lambda, x, y)
        
        function p = isProx_(op)
            p = xor(op.inList{1}.isConstant, op.inList{2}.isConstant);
        end
        
        function p = funL(op)
            p = ifelse(op.isProx_, 1, 0);
        end
        
        function p = isGrad_(op)
            p = 1;
        end
       
    end
end