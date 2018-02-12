function type = typeAtA( op )

if isa(op.inputList{1}, 'FourierTransformation')
    type = 3;
elseif isa(op.inputList{1}, 'Variable')

    if op.isAdjoint
        type = 1;
    else
        type = 2;
    end
    
else
    type = 0;
end

end

