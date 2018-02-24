function res = im2row(im, winSize)
%im2col   Rearrange image blocks into rows.
%   B = im2col(A,[M N]) converts each sliding M-by-N block of A into a row 
%   of B. If the size of A is [MM, NN, KK], then the size of B is 
%   (MM-M+1)*(NN-N+1)-by-(M*N)-by-KK.
%
%   See also row2im

%   This code is modified from Michael Lustig's SPIRiT V0.3 library
%   https://people.eecs.berkeley.edu/~mlustig/Software.html

%   Copyright 2018 Junshen Xu

s = size(im);
sx = s(1);
sy = s(2);
sz = s(3:end);

wx = sx-winSize(1);
wy = sy-winSize(2);
patchSize = [(wx+1)*(wy+1), 1, prod(sz)];

res = zeros((wx+1)*(wy+1),prod(winSize),prod(sz));
count=0;
for y=1:winSize(2)
    for x=1:winSize(1)
        count = count+1;
        res(:,count,:) = reshape(im(x:wx+x,y:wy+y,:), patchSize);
    end
end

res = reshape(res, [(wx+1)*(wy+1),prod(winSize), sz]);

