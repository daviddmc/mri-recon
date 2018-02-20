function y = zpadc(x, sizeFull)
%ZPADC   zero pad array
%   Y = ZPADC(X, SIZ) zero pads array X, so that Y is of size SIZ and 
%   X lies in the center of Y.

%   Copyright 2018 Junshen Xu

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
       