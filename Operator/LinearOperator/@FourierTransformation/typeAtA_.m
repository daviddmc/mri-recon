function t = typeAtA_(op, t)

if t.type == 2  || t.type == 4
    t.type = 3;
    t.dimF = op.dim;
    if op.isAdjoint
        t.F = -1;
    else
        t.F = 1;
    end
elseif t.type == 3% || t.type == 4
    t.type = 0;
end

if ~isfield(t, 'dimN')
    t.dimN = [];
end

end

