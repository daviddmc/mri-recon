function res = im2row(im, winSize)

s = size(im);
sx = s(1);
sy = s(2);
sz = s(3:end);
%[sx,sy,sz] = size(im);

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

