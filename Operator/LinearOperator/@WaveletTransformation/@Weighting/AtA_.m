function ata = AtA_(m, a)

if isempty(a)
    ata = conj(m.w) .* m.w;
else
    ata = conj(m.w) .* m.w .* a; 
end

end

