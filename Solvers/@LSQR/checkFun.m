function checkFun(lq)

len = length(lq.inList);
lq.AList = lq.inList(1 : len / 2);
lq.bList = lq.inList(len/2 + 1 : end);

%I.apply = @(x)x;
%I.adjoint = @(x)x;

for ii = 1 : len / 2
    if ~lq.AList{ii}.isLinear
        error(['A{' num2str(ii) '} must be linear.']);
    end
    
    if ~lq.bList{ii}.isConstant
        error(['b{' num2str(ii) '} must be a constant.']);
    end
    
end

end


