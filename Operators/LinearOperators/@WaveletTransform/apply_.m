function y = apply_(wt, x, ~)

if nargout > 0
    if wt.isAdjoint
        S = size(x);
        x = reshape(x,S(1),S(2),prod(S(3:end)));
        y = 0*x;

        for n = 1:size(x,3)
            y(:,:,n) = IWT2_PO(real(x(:,:,n)),wt.scale,wt.qmf) + 1i*IWT2_PO(imag(x(:,:,n)),wt.scale,wt.qmf);
        end

        y = reshape(y,[size(y,1),size(y,2),S(3:end)]);
    else

        S = size(x);
        x = reshape(x,S(1),S(2),prod(S(3:end)));

        y = 0*x;

        for n = 1:size(x,3)
            y(:,:,n) = FWT2_PO(real(x(:,:,n)),wt.scale,wt.qmf) + 1i* FWT2_PO(imag(x(:,:,n)),wt.scale,wt.qmf);
        end

        y = reshape(y,[size(y,1),size(y,2),S(3:end)]);

    end
end

