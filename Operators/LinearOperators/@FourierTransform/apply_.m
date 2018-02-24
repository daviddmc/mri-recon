function y = apply_(ft, x, ~)

if nargout > 0
    if ft.isAdjoint
        sizeX = size(x);
        ftr = sqrt(prod(sizeX(ft.dim)));

        y = x;
        for ii = ft.dim
            y = ifftshift(y,ii);
        end
        for ii = ft.dim
            y = ifft(y,[],ii);
        end
        for ii = ft.dim
            y = fftshift(y,ii);
        end

        y = ftr * y;
    else
        sizeX = size(x);
        ftr = sqrt(prod(sizeX(ft.dim)));

        y = x;

        for ii = ft.dim
            y = ifftshift(y,ii);
        end
        for ii = ft.dim
            y = fft(y,[],ii);
        end
        for ii = ft.dim
            y = fftshift(y,ii);
        end

        y = 1/ftr * y;
    end
end