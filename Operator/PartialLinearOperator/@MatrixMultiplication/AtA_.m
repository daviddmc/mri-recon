function ata = AtA_(op, ata)

if isempty(ata)
    if op.inputList{1}.isConstant
        ata = op.inputList{1}.cache * op.inputList{1}.cache';
    else
        ata = op.inputList{2}.cache * op.inputList{2}.cache';
    end
else
    if op.inputList{1}.isConstant
        ata = op.inputList{1}.cache * ata * op.inputList{1}.cache';
    else
        ata = op.inputList{2}.cache * ata * op.inputList{2}.cache';
    end
end

