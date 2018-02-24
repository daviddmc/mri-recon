function y = Afun(lq, x, iter, sizeX, tflag)

persistent sizeList nList;

if tflag
    if lq.lambdas(1) == 1
        y = lq.AList{1}.adjoint(reshape(x(1:nList(1)), sizeList{1}));
    else
        y = lq.lambdas(1) * lq.AList{1}.adjoint(reshape(x(1:nList(1)), sizeList{1}));
    end
    
    for ii = 2 : length(lq.AList)
        if lq.lambdas(ii) == 1
            y = y + lq.AList{ii}.adjoint(reshape(x(nList(ii-1)+1:nList(ii)), sizeList{ii}));
        else
            y = y + lq.lambdas(ii) * lq.AList{ii}.adjoint(reshape(x(nList(ii-1)+1:nList(ii)), sizeList{ii}));
        end
    end
    y = y(:);
else
    len = length(lq.AList);
    y = cell(1, len);
    x = reshape(x, sizeX);
    for ii = 1 : length(lq.AList)
        y{ii} = lq.AList{ii}.apply(x);
        if iter == 1
            sizeList{ii} = size(y{ii});
            nList(ii) = prod(sizeList{ii});
            if ii > 1
                nList(ii) = nList(ii) + nList(ii - 1);
            end
        end
        if lq.lambdas(ii) ~= 1
            y{ii} = lq.lambdas(ii) * y{ii}(:);
        else
            y{ii} = y{ii}(:);
        end
    end
    
    y = cat(1,y{:});
end

end