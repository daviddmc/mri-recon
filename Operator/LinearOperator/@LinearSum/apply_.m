function y = apply_( ls, x, ~)

if ls.isAdjoint
    if ls.signList(1) == 1
        y = ls.AList{1}.adjoint(x);
    else
        y = -ls.AList{1}.adjoint(x);
    end
    for ii = 2 : length(ls.AList)
        if ls.signList(ii) == 1
            y = y + ls.AList{ii}.adjoint(x);
        else
            y = y - ls.AList{ii}.adjoint(x);
        end
    end
else
    if ls.signList(1) == 1
        y = ls.AList{1}.apply(x);
    else
        y = -ls.AList{1}.apply(x);
    end
    for ii = 2 : length(ls.AList)
        if ls.signList(ii) == 1
            y = y + ls.AList{ii}.apply(x);
        else
            y = y - ls.AList{ii}.apply(x);
        end
    end
end


