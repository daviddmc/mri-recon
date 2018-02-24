function t = typeAtA_(op, t)

if op.isAdjoint
    t.type = 0;
else
    if t.type == 1
        t.type = 2;
        t.dimN = [];
    else
        t.type = 0;
    end
end

end

