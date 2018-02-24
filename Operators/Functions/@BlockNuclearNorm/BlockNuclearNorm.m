classdef BlockNuclearNorm < Functional
    
    properties
        blockSize
    end
    
    methods
        function nuc = BlockNuclearNorm(inputList, mu, blockSize)
            nuc = nuc@Functional(inputList, mu, 1);
            nuc.blockSize = blockSize;
        end
    end
    
    methods(Access = protected)
        y = eval_(nuc, x, isCache)
        
        z = prox_(nuc, lambda, x)
        
        g = gradOp_(nuc, x)
        
        function p = isProx_(op)
            p = 1;
        end
    end
    
end