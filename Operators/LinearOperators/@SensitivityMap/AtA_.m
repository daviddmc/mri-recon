function ata = AtA_(m, a)

if isempty(m.ata)
    m.ata = sum(conj(m.map) .* m.map, ndims(m.map));
end

ata = m.ata;

if ~isempty(a)
    ata = ata .* a;
end

end

