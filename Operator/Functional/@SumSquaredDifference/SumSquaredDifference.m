classdef SumSquaredDifference < Functional
    
    methods
        function ssd = SumSquaredDifference(inputList, mu)
            ssd = ssd@Functional(1, 1, 1, mu, inputList);
            ssd.updateProp_();
        end
        
    end
    
    methods
        z = proxA(ssd, lambda, A, x);
    end
    
    methods(Access = protected)
        y = eval_(ssd, x1, x2, isCache)
        
        [g1, g2] = gradOp_(ssd, preGrad)
        
        z = prox_(ssd, lambda, x, y)
        
        function updateProp_(ssd)
            if ~ssd.inputList{1}.isConstant && ~ssd.inputList{2}.isConstant
                ssd.isProx_ = 0;
                ssd.L_ = 0;
            end
        end
    end
end