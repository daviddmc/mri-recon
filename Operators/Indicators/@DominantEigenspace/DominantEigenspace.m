classdef DominantEigenspace < Indicator
    
    methods
        function de = DominantEigenspace(inputList, A)
            if iscell(inputList)
                inputList = [inputList, {A}];
            else
                inputList = {inputList, A};
            end
            de = de@Indicator(inputList, 1);
        end
    end
    
    methods(Access = protected)
        z = prox_(de, lambda, x)
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    end
    
end

