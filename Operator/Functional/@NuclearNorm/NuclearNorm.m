classdef NuclearNorm < Functional
    
    properties
        dim
        p
    end
    
    methods
        function nuc = NuclearNorm(inputList, mu, dim, p, option)
            nuc = nuc@Functional(1, 1, 0, mu, inputList);
            nuc.dim = dim;
            if nargin < 4
                nuc.p = 1;
            else
                nuc.p = p;
            end
            if nargin < 5
                option = [];
            end
            if isfield(option, 'type')
                nuc.proxOption.type = option.type;
            else
                nuc.proxOption.type = 1;
            end

            if isfield(option, 'maxIter')
                nuc.proxOption.maxIter = option.maxIter;
            else
                nuc.proxOption.maxIter = 10;
            end
            
        end
    end
    
    methods(Access = protected)
        y = eval_(nuc, x, isCache)
        
        z = prox_(nuc, lambda, x)
        
        g = gradOp_(nuc, x)
        function updateProp_(op);end
    end
    
end