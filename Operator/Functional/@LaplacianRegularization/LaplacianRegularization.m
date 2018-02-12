classdef LaplacianRegularization < Functional
    
    properties
        eigvalue
        dim
        sizeTrans
    end
    
    methods
        function LapReg = LaplacianRegularization(inputList, mu, dim)
            LapReg = LapReg@Functional(0, 1, (4*dim)^2, mu, inputList);
            LapReg.dim = dim;
            LapReg.sizeTrans = zeros(1, dim);
        end 
    end
    
    methods(Access = protected)
        y = eval_(LapReg, x, isCache)
        g = gradOp_(LapReg, preGrad)
        z = prox_(LapReg, lambda, x)
        function updateProp_(op);end
    end
    
end
        