function ata = AtA_(op, ata)
    if isempty(ata)
        ata = op.unitary ^ 2;
    else
        ata = ata * op.unitary^2;
    end
end

