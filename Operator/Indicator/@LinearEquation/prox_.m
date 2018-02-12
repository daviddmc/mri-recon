function z = prox_( lineq, ~, a, b)

if lineq.inputList{1}.isConstant
    z = a;
else
    z = b;
end

end

