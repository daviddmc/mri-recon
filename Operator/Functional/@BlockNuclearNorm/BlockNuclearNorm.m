classdef BlockNuclearNorm < Functional
    
    properties
        blockSize
    end
    
    methods
        function nuc = BlockNuclearNorm(inputList, mu, blockSize)
            nuc = nuc@Functional(1, 0, 0, mu, inputList);
            nuc.blockSize = blockSize;
        end
    end
    
    methods(Access = protected)
        y = eval_(nuc, x, isCache)
        
        z = prox_(nuc, lambda, x)
        
        g = gradOp_(nuc, x)
        
        function updateProp_(op);end
    end
    
end