classdef SchattenNorm < Functional
    
    % ||sigma||_p^p / p
    
    properties
        dim
        p
    end
    
    methods
        function nuc = SchattenNorm(inputList, mu, p, dim)
            nuc = nuc@Functional(inputList, mu, 1);
            nuc.dim = dim;
            nuc.p = p;
        end
    end
    
    methods(Access = protected)
        y = eval_(nuc, x, isCache)
        
        z = prox_(nuc, lambda, x)
        
        g = gradOp_(nuc, x)
        
        function p = isGrad_(op)
            p = op.p > 1; 
        end
        function p = isProx_(op)
            p = 1;
        end
    end
    
end