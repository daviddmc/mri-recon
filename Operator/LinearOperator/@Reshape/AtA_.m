function ata = AtA_(rs, a)

if isempty(a)
    ata = 1;
else
    if numel(a) == 1
        ata = a;
    else
        ata = reshape(a, rs.sizeIn);
    end
end

end

