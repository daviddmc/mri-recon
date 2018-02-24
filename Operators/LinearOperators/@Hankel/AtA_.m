function ata = AtA_(h, a)

ata = row2im([], h.sizeIn, h.sizeKernel);

if ~isempty(a)
    ata = ata *a;
end

end

