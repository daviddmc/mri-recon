function y = eval_(LapReg, x, isCache)

sizeX = size(x);
if any(sizeX(1:LapReg.dim) ~= LapReg.sizeTrans)
    LapReg.sizeTrans = sizeX(1:LapReg.dim);
    LapReg.eigvalue = laplaceEig(LapReg.sizeTrans);
end

dctX = DCT(x, LapReg.dim);
tmp = (LapReg.eigvalue.^2) .* dctX;
if isCache
    LapReg.cache = tmp;
end

if nargout > 0
    y = 0.5 * (dctX(:)' * tmp(:));
    y = real(y);
end
    %dctX = DCT(x, LapReg.dim);
    %dctX = LapReg.eigvalue .* dctX;
    %y = 0.5 * (dctX(:)'*dctX(:));
  
end