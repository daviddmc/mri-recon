%function [res, im_int]=mirt2D_register(refim, im, main, optim)


% Check the input options and set the defaults
%if nargin<2, error('mirt2D_register error! Not enough input parameters.'); end;

% Check the proper parameter initilaization
% [main,optim]=mirt_check(main,optim,nargin);

clear all; close all; clc;
load mirt2D_data1.mat;

 % Main settings
%main.similarity='ssd';  % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS, MI 
subdivide=3;       % use 3 hierarchical levels
okno=5;            % mesh window size
lambda = 0.005;    % transformation regularization weight, 0 for none
%main.single=1;          % show mesh transformation at every iteration

% Optimization settings
maxsteps = 200;   % maximum number of iterations at each hierarchical level
fundif = 1e-5;    % tolerance (stopping criterion)
gamma = 1;       % initial optimization step size 
anneal = 0.8;       % annealing rate on the optimization step    


% Original image size
dimen=size(refim);
% Size at the smallest hierarchical level, when we resize to smaller
M=ceil(dimen/2^(subdivide-1));
% Generate B-splines mesh of control points equally spaced with main.okno spacing
% at the smallest hierarchical level (the smallest image size)
[x, y]=meshgrid(1-okno:okno:M(2)+2*okno, 1-okno:okno:M(1)+2*okno);
% the size of the B-spline mesh is in (main.mg, main.ng) at the smallest
% hierarchival level.
[mg, ng]=size(x);

% new image size at the smallest hierarchical level
% this image size is equal or bigger than the original resized image at the
% smallest level. This size includes the image and the border of nans when the image size can not be
% exactly divided by integer number of control points.
siz=[(mg-3)*okno (ng-3)*okno];

x = cat(3,x,y);  % Put x and y control point positions into a single mg x ng x 2 3Dmatrix
xgrid = x;  % save the regular grid (used for regularization to find the displacements)

%main.F=mirt2D_F(main.okno); % Init B-spline coefficients

tmp=zeros(2^(subdivide-1)*siz);
tmp(1:dimen(1),1:dimen(2))=refim;  refim=tmp;
tmp(1:dimen(1),1:dimen(2))=im;     im=tmp;
clear tmp;

% Go across all sub-levels
for level=1:subdivide
    
    % update the size of B-spline mesh to twice bigger 
    % only do it for the 2nd or higher levels 
    if level>1
        mg=2*mg-3; % compute the new mesh size
        ng=2*ng-3;
    end
    
    % current image size
    siz=[(mg-3)*okno (ng-3)*okno];
    
    refimsmall=imresize(refim, siz, 'bicubic'); % resize images
    refimsmall(refimsmall<0)=0;  
    refimsmall(refimsmall>1)=1;
    
    imsmall=imresize(im, siz, 'bicubic'); 
    imsmall(imsmall<0)=0;
    imsmall(imsmall>1)=1;
    
    bm = BsplineMotion([], 0, 0, okno, [mg, ng]);
    md = MotionDeformation({bm, imsmall}, 'bilinear', 0);
    ssd = SumSquaredDifference({md, refimsmall}, 1);

    regLap = LaplacianRegularization(Minus({[], xgrid}), lambda, 2);
    
    param.beta = anneal;
    param.t0 = gamma;
    param.tol = fundif;
    param.maxIter = maxsteps;
    param.verbose = 2;
    [x, info] = NLCG({ssd, regLap}, {[], []}, x, param);
    
    % if the sublevel is not last prepair for the next level
    if level < subdivide
        x = upsamplingGrid(x, 1);
        xgrid = upsamplingGrid(xgrid, 1);
    end
    
end

% because we have appended the initial images with the border of NaNs during the
% registration, now we want to remove that border and get the result of the
% initial image size
result = md.apply(x);
%im_int=zeros(dimen); [M,N]=size(result);
%im_int(1:min(dimen(1),M),1:min(dimen(2),N))=result(1:min(dimen(1),M),1:min(dimen(2),N));


disp('MIRT: 2D B-spline based registration is succesfully completed.')

figure,imshow(refim); title('Reference (fixed) image');
figure,imshow(im);    title('Source (float) image');
figure,imshow(result); title('Registered (deformed) image');
