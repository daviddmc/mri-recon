function ata = AtA_(G, a)

if isempty(G.AtAeig) 
    v = 0;
    for ii = 1 : length(G.dim)
        d = G.dim(ii);
        s = G.sizeX(d);
        if isempty(G.weight)
            w = 1;
        else
            w = G.weight(ii) ^ 2;
        end
        v = v + w * reshape(ifftshift(2 - 2 * cos(2*pi*(0:s-1)/s)), [ones(1, d-1), s, 1]);
    end
    G.AtAeig = v;
end

ata = G.AtAeig;

if ~isempty(a)
    ata = ata .* a;
end

end

