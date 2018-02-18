function ata = AtA(op)

op.preConstant();
ata = [];
for ii = length(op.topoSort) : -1 : 1
    
    if ~op.topoSort{ii}.isConstant
        ata = op.topoSort{ii}.AtA_(ata);
    end
    
end
end

