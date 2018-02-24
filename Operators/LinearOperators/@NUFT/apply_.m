function y = apply_(nuft, x, ~)


if nargout > 0
    if nuft.isAdjoint
        fac = sqrt(prod(nuft.sizeIm));

        y = zeros([nuft.sizeIm, nuft.nc, nuft.nt]);
        for t = 1 : nuft.nt 
            for c = 1 : nuft.nc
                k = x(:,:,c,t) .* nuft.dcf(:, :, t);
                y(:,:,c,t) = reshape(...
                    nufft_adj(k(:), nuft.nufft_obj{t}) / fac ,...
                    nuft.sizeIm);
            end
        end


        if ~isempty(nuft.smap)
            y = squeeze(sum(y .* conj(nuft.smap), 3));
        end

    else
        fac = sqrt(prod(nuft.sizeIm));

        y = zeros([nuft.sizeK, nuft.nc, nuft.nt]);

        if isempty(nuft.smap)
            for t = 1 : nuft.nt
                for c = 1 : nuft.nc
                    y(:,:,c,t) = reshape(...
                        nufft(x(:,:,c,t), nuft.nufft_obj{t}) / fac, ...
                        nuft.sizeK) .* nuft.dcf(:,:,t);
                end
            end
        else
            for t = 1 : nuft.nt
                for c = 1 : nuft.nc
                    res = x(:,:,t) .* nuft.smap(:,:,c);
                    y(:,:,c,t) = reshape(...
                        nufft(res, nuft.nufft_obj{t}) / fac, ...
                        nuft.sizeK) .* nuft.dcf(:,:,t);
                end
            end
        end


        y = squeeze(y);
    end

end
