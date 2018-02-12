classdef Functional < Operator
    
    properties(SetAccess = protected)
        isProx_ = 0;
        mu = 1;
        proxOption
    end
    
    methods
        % constructor
        function fun = Functional(isProx, isGrad, L, mu, inputList)
            fun = fun@Operator(inputList);
            fun.mu = mu;
            fun.isLinear_ = 0;
            fun.proxOption.maxIter = 10;
            fun.proxOption.method = 1;%ADMM
            
            
            fun.updateProp(isProx, isGrad, L);
        end
        
        y = eval(fun, varargin)
        z = prox(fun, lambda, x, H)
        varargout = grad(fun, varargin)
        z = proxConj(fun, lambda, x)
        %y = JacOp(fun, varargin)
        p = isProx(op)
    end
    
    methods(Access = protected)
        updateProp(fun, isProx, isGrad, L)
        %y = JacOp_(fun, varargin)
        f = apply_( fun, varargin )
    end
    
    methods(Access = protected, Abstract)
        y = eval_(fun, x)
        z = prox_(fun, lambda, x)
        updateProp_(fun)
    end
   
end