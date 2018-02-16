classdef DominantEigenspace < Indicator
    
    properties
        A
    end
    
    methods
        function de = DominantEigenspace(inputList, A)
            de = de@Indicator(inputList);
            de.A = A;
        end
    end
    
    methods(Access = protected)
        z = prox_(de, lambda, x)
    end
    
end

