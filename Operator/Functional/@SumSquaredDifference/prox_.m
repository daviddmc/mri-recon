function z = prox_(ssd, lambda, x, y)

if ssd.inputList{1}.isConstant
    z = (lambda * x + y) / (lambda + 1);
else
    z = (lambda * y + x) / (lambda + 1);
end

end