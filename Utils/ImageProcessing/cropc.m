function y = cropc(x, cropSize)
%CROPC   crop the center of an array
%   Y = CROPC(X, SIZ) crops the center of X of size SIZ.

%   Copyright 2018 Junshen Xu

sizeFull = size(x);
sizeFull = sizeFull(1 : length(cropSize));

idxEnd = sizeFull;
idxStart = 0*sizeFull + 1;

oddPad = mod(sizeFull - cropSize, 2);
sizePad = (sizeFull - cropSize - oddPad) / 2;

idxStart =  idxStart + oddPad + sizePad;
idxEnd = idxEnd - sizePad;

var = cell(1, ndims(x));
var(:) = {':'};

for ii = 1 : length(idxStart)
    var{ii} = idxStart(ii):idxEnd(ii);
end

y = x(var{:});

       


    