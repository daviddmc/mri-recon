classdef SeparableSum < Functional
    
    properties
        %funList = {};
    end
    
    methods
        function ss = SeparableSum(inputList, mu)
            
            ss = ss@Functional(1, 1, 1, mu, inputList);
            %ss = ss@Functional(isProx, isGrad, sqrt(L2), [], mu);
            
        end
        
        p = isProx(op);
        
        y = eval(fun, varargin)
        z = prox(fun, lambda, x, H)
        varargout = grad(fun, varargin)
    end
    
    methods(Access = protected)
        function y = eval_(fun, x, isCache)
            error(' ');
        end
        function z = prox_(fun, lambda, x)
            error(' ');
        end
        function g = gradOp_(fun, x)
            error(' ');
        end
        updateProp(fun, isProx, isGrad, L)
        function updateProp_(op)
        end
    end
end
    
   