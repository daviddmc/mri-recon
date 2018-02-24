function ata = AtA_(G, a)

if isempty(G.AtAeig) 
    G.AtAeig = laplaceEig(G.sizeX, G.dim, G.weight, 'p');
end

ata = G.AtAeig;

if ~isempty(a)
    ata = ata .* a;
end

end

