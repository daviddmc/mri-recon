classdef NuclearNorm < Functional
    
    properties
        dim
    end
    
    methods
        function nuc = NuclearNorm(inputList, mu, dim)
            nuc = nuc@Functional(inputList, mu, 1);
            nuc.dim = dim;
        end
    end
    
    methods(Access = protected)
        y = eval_(nuc, x, isCache)
        
        z = prox_(nuc, lambda, x)
        
        g = gradOp_(nuc, x)
        function p = isProx_(op)
            p = 1;
        end
    end
    
end