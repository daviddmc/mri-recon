function y = apply_( ls, x, ~)

if ls.isAdjoint
    if ls.signList(1) == 1
        y = ls.inList{2}.adjoint(x);
    else
        y = -ls.inList{2}.adjoint(x);
    end
    for ii = 2 : length(ls.signList)
        if ls.signList(ii) == 1
            y = y + ls.inList{ii+1}.adjoint(x);
        else
            y = y - ls.inList{ii+1}.adjoint(x);
        end
    end
else
    if ls.signList(1) == 1
        y = ls.inList{2}.apply(x);
    else
        y = -ls.inList{2}.apply(x);
    end
    for ii = 2 : length(ls.signList)
        if ls.signList(ii) == 1
            y = y + ls.inList{ii+1}.apply(x);
        else
            y = y - ls.inList{ii+1}.apply(x);
        end
    end
end


