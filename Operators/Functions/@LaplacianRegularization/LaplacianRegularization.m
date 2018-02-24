classdef LaplacianRegularization < Functional
    
    properties
        eigvalue
        dim
        sizeTrans
    end
    
    methods
        function LapReg = LaplacianRegularization(inputList, mu, dim)
            LapReg = LapReg@Functional(inputList, mu, 1);
            LapReg.dim = dim;
            LapReg.sizeTrans = zeros(1, dim);
        end 
    end
    
    methods(Access = protected)
        y = eval_(LapReg, x, isCache)
        g = gradOp_(LapReg, preGrad)
        z = prox_(LapReg, lambda, x)
        function p = isGrad_(op)
            p = 1;
        end
        function p = funL(op)
            p = (4*op.dim)^2;
        end
    end
    
end
        