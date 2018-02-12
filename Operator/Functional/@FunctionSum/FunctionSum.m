classdef FunctionSum < Functional
    
    properties
        savefun
        idxLinear
        idxNonLinear
    end
    
    methods
        function fs = FunctionSum(inputList)
            fs = fs@Functional(0, 1, 0, 1, inputList);
        end
        
        [y, gList] = funGrad(fs, isfun, xList, t, pList);
      
    end

    methods(Access = protected)
        updateProp(fun, isProx, isGrad, L)
        function updateProp_(fun)
        end
        z = prox_(fun, lambda, x)
        y = eval_(fun, varargin);
        varargout = gradOp_(fun, preGrad)
    end

    
end
    
   