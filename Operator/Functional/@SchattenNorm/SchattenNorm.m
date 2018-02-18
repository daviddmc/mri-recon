classdef SchattenNorm < Functional
    
    % ||sigma||_p^p / p
    
    properties
        dim
        p
    end
    
    methods
        function nuc = SchattenNorm(inputList, mu, p, dim)
            nuc = nuc@Functional(1, 1, 0, mu, inputList);
            nuc.dim = dim;
            nuc.p = p;
        end
    end
    
    methods(Access = protected)
        y = eval_(nuc, x, isCache)
        
        z = prox_(nuc, lambda, x)
        
        g = gradOp_(nuc, x)
        function updateProp_(op);end
    end
    
end