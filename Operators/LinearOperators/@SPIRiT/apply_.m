function y = apply_( S, x, ~)


if nargout > 0
    if S.isAdjoint
        
        nc = size(S.map, 4);
        y = zeros(size(x));
        if strcmpi(S.type, 'image')
            for n=1:nc
                tmpk = squeeze(conj(S.map(:,:,n,:)));
                y(:,:,n) = sum(tmpk.*x,3); 
            end
            if S.isMinusI
                y = y - x;
            end
        else
            xx = ifftc(x, [1,2]);
            for n=1:nc
                tmpk = squeeze(conj(S.map(:,:,n,:)));
                y(:,:,n) = sum(tmpk.*xx,3); 
            end
            if S.isMinusI
                y = fftc(y, [1,2])-x;
            else
                y = fftc(y, [1,2]);
            end
        end
    else
        nc = size(S.map, 4);
        y = zeros(size(x));
        if strcmpi(S.type, 'image')

            for n=1:nc
                tmpk = S.map(:,:,:,n);
                y(:,:,n) = sum(tmpk.*x,3); 
            end

            if S.isMinusI
                y = y-x;
            end

        else

            xx = ifftc(x, [1,2]);
            for n = 1 : nc
                tmpk = S.map(:,:,:,n);
                y(:,:,n) = sum(tmpk .* xx, 3);
            end

            if S.isMinusI
                y = fftc(y, [1,2])-x;
            else
                y = fftc(y, [1,2]);
            end
        end

    end

end
