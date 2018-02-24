function t = typeAtA_(op, t)

if t.type ==1 && ~op.isAdjoint
    t.type = 2;
else
    t.type = 0;
end

end

