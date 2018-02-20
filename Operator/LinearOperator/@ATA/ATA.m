classdef ATA < LinearOperator

    properties
        A
    end
    
    methods
        function ata = ATA(inputList, A)
            ata = ata@LinearOperator([], 0, inputList);
            ata.A = A;
        end

    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
    end
    
end

