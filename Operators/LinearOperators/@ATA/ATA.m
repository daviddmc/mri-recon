classdef ATA < LinearOperator

    
    methods
        function ata = ATA(inputList, A)
            if iscell(inputList)
                inputList = [inputList {A}];
            else
                inputList = {inputList, A};
            end
            ata = ata@LinearOperator(inputList, 0);
        end

    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        [propChanged, isStructChanged] = receive(op, pos, propChanged, isStructChanged)
    end
    
end

