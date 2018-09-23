function ata = AtA_(m, a)
%{
if m.isAdjoint
    if m.isReduced
        ata = 1;
    else
        ata = m.mask;
    end
else
    if m.isReduced
        ata = zeros(m.sizeMask);
        ata(m.idx) = 1;
    else
        ata = m.mask;
    end    
end

if ~isempty(a)
    ata = ata .* a;
end
%}
end

