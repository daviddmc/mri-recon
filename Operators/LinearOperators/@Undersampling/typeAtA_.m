function t = typeAtA_(op, t)

if op.isAdjoint
    if t.type == 1 && op.isReduced
        t.type = 1;
    elseif t.type == 1 || t.type == 2
        t.type = 2;
        t.dimN = [];
        s = size(op.mask);
        for ii = 1 : length(s)
            if s(ii) ~= 1
                t.dimN = [t.dimN ii];
            end
        end
    else
        t.type = 0;
    end
else
    if t.type == 1 || t.type == 2
        t.type = 2;
        t.dimN = [];
        s = size(op.mask);
        for ii = 1 : length(s)
            if s(ii) ~= 1
                t.dimN = [t.dimN ii];
            end
        end
    else
        t.type = 0;
    end
end

end

