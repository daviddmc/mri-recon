classdef SumAbsoluteDifference < Functional
    
    methods
        function sad = SumAbsoluteDifference(inputList, mu)
            sad = sad@Functional(1, 1, 1, mu, inputList);
            sad.updateProp_();
        end
        
    end
    
    methods(Access = protected)
        y = eval_(sad, x1, x2, isCache)
        
        [g1, g2] = gradOp_(sad, preGrad)
        
        z = prox_(sad, lambda, x, y)
        
        function updateProp_(sad)
            if ~sad.inputList{1}.isConstant && ~sad.inputList{2}.isConstant
                sad.isProx_ = 0;
                sad.L_ = 0;
            end
        end
    end
end