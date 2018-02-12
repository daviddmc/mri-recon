function [res, W] = row2im(mtx,imSize, winSize, flag)

sx = imSize(1); 
sy = imSize(2);
if flag == 2
    sz = imSize(3 : end);
else
    s = size(mtx);
    sz = s(3 : end);
end
wx = sx-winSize(1);
wy = sy-winSize(2);
pSize = [(wx+1),(wy+1),prod(sz)];

count=0;
if flag == 0
    res = zeros(imSize(1),imSize(2),prod(sz));
    for y=1:winSize(2)
        for x=1:winSize(1)
            count = count+1;
            res(x:wx+x,y:wy+y,:) = res(x:wx+x,y:wy+y,:) + reshape(mtx(:,count,:),pSize);
        end
    end
    res = reshape(res, [imSize, sz]);
    W = [];
elseif flag == 1
    res = zeros(imSize(1),imSize(2),prod(sz));
    W = res;
    for y=1:winSize(2)
        for x=1:winSize(1)
            count = count+1;
            res(x:wx+x,y:wy+y,:) = res(x:wx+x,y:wy+y,:) + reshape(mtx(:,count,:),pSize);
            W(x:wx+x,y:wy+y,:) = W(x:wx+x,y:wy+y,:)+1;
        end
    end
    res = res./W;
    res = reshape(res, [imSize, sz]);
    W = reshape(W, [imSize, sz]);
else
    W = zeros(imSize(1),imSize(2),prod(sz));
    for y=1:winSize(2)
        for x=1:winSize(1)
            count = count+1;
            W(x:wx+x,y:wy+y,:) = W(x:wx+x,y:wy+y,:)+1;
        end
    end
    W = reshape(W, imSize);
    res = [];
end
