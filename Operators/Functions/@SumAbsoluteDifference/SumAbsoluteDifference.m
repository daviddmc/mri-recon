classdef SumAbsoluteDifference < Functional
    
    methods
        function sad = SumAbsoluteDifference(inputList, mu)
            sad = sad@Functional(inputList, mu, 2);
        end
        
    end
    
    methods(Access = protected)
        y = eval_(sad, x1, x2, isCache)
        
        [g1, g2] = gradOp_(sad, preGrad)
        
        z = prox_(sad, lambda, x, y)
        
        function p = isProx_(op)
            p = xor(op.inList{1}.isConstant, op.inList{2}.isConstant);
        end
        
        function p = isGrad_(op)
            p = 1;
        end
        
    end
end