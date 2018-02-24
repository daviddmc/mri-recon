function t = typeAtA_( m , t)

if t.type == 1 || t.type == 2
    t.type = 2;
    t.dimN = [];
    s = size(m.w);
    for ii = 1 : length(s)
        if s(ii) ~= 1
            t.dimN = [t.dimN ii];
        end
    end
else
    t.type = 0;
end

end

