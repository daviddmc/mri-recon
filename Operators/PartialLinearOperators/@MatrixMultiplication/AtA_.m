function ata = AtA_(op, ata)

if isempty(ata)
    if op.inList{1}.isConstant
        ata = op.inList{1}.cache * op.inList{1}.cache';
    else
        ata = op.inList{2}.cache * op.inList{2}.cache';
    end
else
    if op.inList{1}.isConstant
        ata = op.inList{1}.cache * ata * op.inList{1}.cache';
    else
        ata = op.inList{2}.cache * ata * op.inList{2}.cache';
    end
end

