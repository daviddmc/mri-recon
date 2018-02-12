function y = padCenter(x, sizeFull)

sizeCenter = size(x);
sizeCenter = sizeCenter(1 : length(sizeFull));

oddPad = mod(sizeFull - sizeCenter, 2); 
if any(oddPad)
    x = padarray(x, oddPad, 0, 'pre');
end

sizePad = (sizeFull - sizeCenter - oddPad) / 2;
if any(sizePad)
    y = padarray(x, sizePad);
end
       