function type = typeAtA( op )

if isa(op.inputList{1}, 'FourierTransformation')
    type = 3;
elseif isa(op.inputList{1}, 'Variable')

    type = 2;
    
else
    type = 0;
end

end

