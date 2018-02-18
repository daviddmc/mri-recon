function t = typeAtA_(op, t)

if ~op.isAdjoint && t.type == 1
    t.type = 3;
    t.dimF = op.dim;
    t.F = 0;
    t.dimN = op.dim;
else
    t.type = 0;
end

end

