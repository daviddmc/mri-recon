function im = row2im(rows, imSize, winSize, normalized)
%row2im   Rearrange matrix rows into blocks.
%   A = row2im(B, IMSIZE, WINSIZE, NORMALIZED) rearranges the result of 
%   IM2COL to images. NORMALIZED is a flag indicating whether the result
%   will be normalized.
%
%   W = row2im([], IMSIZE, WINSIZE) is the normalized factor.
%
%   See also im2row

%   This code is modified from Michael Lustig's SPIRiT V0.3 library
%   https://people.eecs.berkeley.edu/~mlustig/Software.html

%   Copyright 2018 Junshen Xu

sx = imSize(1); 
sy = imSize(2);
isW = isempty(rows);
if isW
    sz = imSize(3 : end);
else
    s = size(rows);
    sz = s(3 : end);
end
wx = sx-winSize(1);
wy = sy-winSize(2);
pSize = [(wx+1),(wy+1),prod(sz)];

count=0;

if isW
    W = zeros(imSize(1),imSize(2),prod(sz));
    for y=1:winSize(2)
        for x=1:winSize(1)
            count = count+1;
            W(x:wx+x,y:wy+y,:) = W(x:wx+x,y:wy+y,:)+1;
        end
    end
    im = reshape(W, imSize);
else
    if normalized
        im = zeros(imSize(1),imSize(2),prod(sz));
        W = im;
        for y=1:winSize(2)
            for x=1:winSize(1)
                count = count+1;
                im(x:wx+x,y:wy+y,:) = im(x:wx+x,y:wy+y,:) + reshape(rows(:,count,:),pSize);
                W(x:wx+x,y:wy+y,:) = W(x:wx+x,y:wy+y,:)+1;
            end
        end
        im = im./W;
        im = reshape(im, [imSize, sz]);
    else
        m = zeros(imSize(1),imSize(2),prod(sz));
        for y=1:winSize(2)
            for x=1:winSize(1)
                count = count+1;
                im(x:wx+x,y:wy+y,:) = im(x:wx+x,y:wy+y,:) + reshape(rows(:,count,:),pSize);
            end
        end
        im = reshape(im, [imSize, sz]);
    end
end


