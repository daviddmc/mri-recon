classdef NUFT < LinearOperator
     
    properties(SetAccess = protected)
        dim = [];
        sizeK = [];
        sizeIm = [];
        dcf = [];
        smap = [];
        nufft_obj = {};
        nt = 1;
        nc = 1;
    end
    
    methods
        function nuft = NUFT(inputList, isAdjoint, sizeIm, nt, nc, kSample, dcf, smap)
            nuft = nuft@LinearOperator([], isAdjoint, inputList);
            nuft.dim = length(sizeIm);
            sizeK = size(kSample);
            nuft.sizeK = sizeK(1:2);
            nuft.sizeIm = sizeIm;
            nuft.nt = nt;
            nuft.nc = nc;
            
            if exist('smap', 'var')
                nuft.smap = smap ./ sum(abs((smap)).^2, ndims(smap));
            else
                nuft.smap = [];
            end
            
            if exist('dcf','var')
                nuft.dcf = sqrt(dcf);
            else
                nuft.dcf = 1;
            end
            
            %if ~isempty(nuft.dcf) && ~all(nuft.sizeK == size(nuft.dcf))
            %    error('dcf and k-space sampling must have the same size!');
            %end
            
            kSample = reshape(kSample, prod(nuft.sizeK(1:2)), nuft.nt);

            for tt = 1 : nuft.nt

                om = [real(kSample(:,tt)), imag(kSample(:,tt))] * 2 * pi;%change this later
                Nd = sizeIm;
                Jd = 6 * ones(1, nuft.dim);
                Kd = floor(Nd * 1.5);
                n_shift = Nd / 2;
                nuft.nufft_obj{tt} = nufft_init(om, Nd, Jd, Kd, n_shift, 'kaiser');

            end
                
        end
            
        
        %y = adjoint_(nuft, x);
        
    end
    
    methods(Access = protected)
        y = apply_(nuft, x, isCache);
    end
        
end