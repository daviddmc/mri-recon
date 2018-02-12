function imageShow(varargin)
% imshowf(img )
%
% Basically imshow but fills up the screen
%
% (c) Frank Ong 2015

im = varargin{1};
imageSize = size(im);
screenSize = get(0,'Screensize');
screenSize = floor([screenSize(4),screenSize(3)]*0.67);

im = imresize(im,[screenSize(1),screenSize(1)*imageSize(2)/imageSize(1)],'Method','nearest');

imageSize = size(im);

if (~(imageSize < screenSize))
    im = imresize(im,[screenSize(2)*imageSize(1)/imageSize(2),screenSize(2)],'Method','nearest');
end

switch nargin
    case 1
        imshow(im);
    case 2
        imshow(im,varargin{2});
end