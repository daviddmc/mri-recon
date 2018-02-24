classdef Functional < Operator
    
    properties(SetAccess = protected)
        mu = 1;
        proxOption
    end
    
    methods
        % constructor
        function fun = Functional(inputList, mu, numInput)
            fun = fun@Operator(inputList, numInput);
            fun.mu = mu;
            fun.proxOption.maxIterOuter = 10;
            fun.proxOption.method = 1;%ADMM
        end
        
        y = eval(fun, varargin)
        z = prox(fun, lambda, x, H)
        varargout = grad(fun, varargin)
        z = proxConj(fun, lambda, x)
        setProxOption(fun, varargin)
    end
    
    methods(Sealed)
        p = isProx(op)
    end
    
    methods(Access = protected)
        
        f = apply_( fun, varargin )
        
        function p = isProx_(op)
            p = 0;
        end
        
        function p = funL(op)
            p = 0;
        end
        
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
            
    end
    
    methods(Access = protected, Sealed)
        function p = L_(op)
            p = op.mu * op.funL;
        end
    end
    
    methods(Access = protected, Abstract)
        y = eval_(fun, x)
        z = prox_(fun, lambda, x)

    end
   
end