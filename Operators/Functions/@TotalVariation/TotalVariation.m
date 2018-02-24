classdef TotalVariation < Functional
    
    properties
        dim
        G
        type
    end
    
    methods
        function tv = TotalVariation(inputList, mu, option)
            tv = tv@Functional(inputList, mu, 1);
            defaultOption = struct('dim', [1,2],...
                                   'type', 'isotropic', ... %anisotropic
                                   'weight', [],...
                                   'maxIter', 10,...
                                   'tol', 1e-3);
             fnames = fieldnames(defaultOption);
             for ii = 1 : length(fnames)
                 if ~isfield(option, fnames{ii})
                     option.(fnames{ii}) = defaultOption.(fnames{ii});
                 end
             end
             
             tv.dim = option.dim;
             tv.type = option.type;
             tv.proxOption.tol = option.tol;
             tv.proxOption.maxIterInner = option.maxIter;
             tv.G = Gradient("TVGRAD", 0, option.dim, option.weight);
 
        end
        
        
    end
    
    methods(Access = protected)
        y = eval_(tv, x, isCache);
        y = prox_(tv, lambda, x);
        y = gradOp_(tv, x);
        function p = isProx_(op)
            p = 1;
        end
    end
    
end