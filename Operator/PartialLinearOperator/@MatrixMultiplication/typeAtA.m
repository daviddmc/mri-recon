function type = typeAtA( op )

if isa(op.inputList{1}, 'Variable') && isa(op.inputList{2}, 'Variable')
    type = 4;
else
    type = 0;
end

end

