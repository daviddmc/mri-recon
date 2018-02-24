classdef Slice < LinearOperator
    %RESHAPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        str
        sizeIn
    end
    
    methods
        function s = Slice(inputList, dim, idx, sizeIn)
            s = s@LinearOperator(inputList, 0);
            s.sizeIn = sizeIn;         
            str = cell(1, length(sizeIn));
            str(:) = {':'};
            str{dim} = idx;
            s.str = str;
            
        end
        
    end
    
    methods(Access = protected)
        y = apply_(rs, x, isCache)
        function p = unitary_(op)
            p = 1;
        end
        function p = shapeNotAdjoint(op)
            p = 1;
        end
    end
    
end

