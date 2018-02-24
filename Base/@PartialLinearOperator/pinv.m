function y = pinv(op, x)

[topoSort,~, ~, ~] = op.getTopoList();

y = x;
for ii = length(topoSort) : -1 : 1
    
    if ~topoSort{ii}.isConstant
        y = topoSort{ii}.pinv_(y);
    end
    
end

end

