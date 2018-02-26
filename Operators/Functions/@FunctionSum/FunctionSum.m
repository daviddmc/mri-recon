classdef FunctionSum < Functional
    
    properties
        savefun
        idxLinear
        idxNonLinear
    end
    
    methods
        function fs = FunctionSum(inputList)
            fs = fs@Functional(inputList, 1, length(inputList));
        end
        
        [y, gList] = funGrad(fs, isfun, xList, t, pList);
        f = eval(fun, varargin)
        varargout = grad(fun, varargin)
      
    end

    methods(Access = protected)
        z = prox_(fun, lambda, x)
        y = eval_(fun, varargin);
        varargout = gradOp_(fun, preGrad)
        
        function p = funL(op)
            p = 1;
        end
        function p = isGrad_(op)
            p = 1;
        end
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
        function [topoSort, refList, varList, clearIdx] = getTopoList(op)
            
            flag = isempty(op.topoSort);
            [topoSort, refList, varList, clearIdx] = getTopoList@Operator(op);
            if flag
                for ii = 1 : length(topoSort)
                    if topoSort{ii}.isLinear || topoSort{ii}.isConstant
                        op.idxLinear = [op.idxLinear, ii];
                    else
                        op.idxNonLinear = [op.idxNonLinear, ii];
                    end
                end
            end
            
        end
    end

    
end
    
   