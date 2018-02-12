function y = eval_(nuc, x, isCache)

sizeX = size(x);
x = reshape(x,[prod(sizeX(1:nuc.dim)),prod(sizeX(nuc.dim+1:end))]);

if isCache
    [u,s,v] = svd(x,'econ');
    nuc.cahce = {u,diag(s),v};
else    
    s = svd(x);
end
    
if nargout > 0
    if nuc.p ~= 1
        y = sum(s(:).^nuc.p);
    else
        y = sum(s(:));
    end
end

end