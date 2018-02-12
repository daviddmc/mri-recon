function checkFun(lq)

I.apply = @(x)x;
I.adjoint = @(x)x;

for ii = 1 : length(lq.AList)
    if isempty(lq.AList{ii})
        lq.AList{ii} = I;
    else
        if ~lq.AList{ii}.isLinear
            error(' ');
        end
    end
end

if any(lq.lambdas < 0)
    error(' ');
end

end


