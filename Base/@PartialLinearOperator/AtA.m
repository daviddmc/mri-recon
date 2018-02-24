function ata = AtA(op)

[topoSort,~, ~, ~] = op.getTopoList();
ata = [];
for ii = length(topoSort) : -1 : 1
    
    if ~topoSort{ii}.isConstant
        ata = topoSort{ii}.AtA_(ata);
    end
    
end
end

