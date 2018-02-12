function type = typeAtA( op )

if isa(op.inputList{1}, 'Variable') && ~op.isAdjoint
    type = 2;
else
    type = 0;
end

end

