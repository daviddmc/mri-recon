classdef FunctionSum < Functional
    
    properties
        funList = {};
    end
    
    methods
        function fs = FunctionSum(inputList, mu)
            isProx = true;
            isGrad = true;
            L2 = 0;
            for ii = 1:length(funList)
                isProx = isProx && funList{ii}.isProx;
                isGrad = isGrad && funList{ii}.isGrad;
                L2 = L2 + funList{ii}.L^2;
            end
            fs = fs@Functional(1, 1, sqrt(L2), mu, inputList);
            %ss = ss@Functional(isProx, isGrad, sqrt(L2), [], mu);
            fs.funList = funList;
        end
        
        y = eval_(fun, x)
        z = prox_(fun, lambda, x)
        g = gradOp_(fun, x)
      
    end
    
end
    
   