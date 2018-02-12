classdef SeparableSum < Functional
    
    properties
        funList = {};
    end
    
    methods
        function ss = SeparableSum(inputList, mu, funList)
            isProx = true;
            isGrad = true;
            L2 = 0;
            for ii = 1:length(funList)
                isProx = isProx && funList{ii}.isProx;
                isGrad = isGrad && funList{ii}.isGrad;
                L2 = L2 + funList{ii}.L^2;
            end
            ss = ss@Functional(isProx, isGrad, sqrt(L2), mu, inputList);
            %ss = ss@Functional(isProx, isGrad, sqrt(L2), [], mu);
            
            ss.funList = funList;
            %{
            for ii = 1 : length(funList)
                varOld = funList.varList{1};
                for ii
            end
            %}
        end
    end
    
    methods(Access = protected)
        y = eval_(fun, x, isCache)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, x)
        function updateProp_(op);end
    end
end
    
   