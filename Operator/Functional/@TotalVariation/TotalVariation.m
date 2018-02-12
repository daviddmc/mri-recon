classdef TotalVariation < Functional
    
    properties
        dim
        G
        type
    end
    
    methods
        function tv = TotalVariation(inputList, mu, dim, type, option)
            tv = tv@Functional(1, 0, 0, mu, inputList);
            if exist('type','var')
                if strcmpi(type,'isotropic') || strcmpi(type,'anisotropic')
                    tv.type = type;
                else
                    error('type error');
                end
            else
                tv.type = 'anisotropic';
            end
            
            if ~exist('option','var')
                option = [];
            end
            
            if isfield(option,'maxIter')
                tv.proxOption.maxIter = option.maxIter;
            else
                tv.proxOption.maxIter = 3;
            end
            
            if isfield(option,'tol')
                tv.proxOption.tol = option.tol;
            else
                tv.proxOption.tol = 1e-3;
            end
            
            if ~isfield(option, 'weight')
                option.weight = [];
            end
            
            tv.dim = dim;
            
            tv.G = Gradient("TVGRAD", 0, dim, option.weight);
            
        end
        
        
    end
    
    methods(Access = protected)
        y = eval_(tv, x, isCache);
        y = prox_(tv, lambda, x);
        y = gradOp_(tv, x);
        function updateProp_(op);end
    end
    
end