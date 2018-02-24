classdef SeparableSum < Functional
   
    methods
        function ss = SeparableSum(inputList, mu, funList)
            if iscell(inputList)
                inputList = [inputList, funList];
            else
                inputList = [{inputList} funList];
            end
            ss = ss@Functional(inputList, mu, 1);            
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, x)
        
        function p = isProx_(op)
            p = 1;
            for ii = 2 : length(op.inList)
                p = p && op.inList{ii}.isProx;
            end
        end
        
        function p = isGrad_(op)
            p = 1;
            for ii = 2 : length(op.inList)
                p = p && op.inList{ii}.isGrad;
            end
        end
        
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
        
    end
end
    
   