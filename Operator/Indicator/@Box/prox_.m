function x = prox_(b, ~, x )

if b.flagLow == 1
    x(x < b.low) = b.low;
elseif b.flagLow == 2
    lower = x < b.low;
    x(lower) = b.low(lower);
end

if b.flagHigh == 1
    x(x > b.high) = b.high;
elseif b.flagHigh == 2
    greater = x > b.high;
    x(greater) = b.high(greater);
end

end

