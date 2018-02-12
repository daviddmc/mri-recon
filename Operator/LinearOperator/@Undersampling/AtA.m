function ata = AtA(m)

if m.isAdjoint
    ata = 1;
else
    if m.isReduced
        ata = zeros(m.sizeMask);
        ata(m.idx) = 1;
    else
        ata = m.mask;
    end
end

end

