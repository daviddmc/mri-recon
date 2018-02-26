%% DEMO Multi-scale Bspline Registration

clear all; 
close all; 

%% load data
load mirt2D_data1.mat;

%% parameters
nscale = 3; % number of scales
spacing = 5;            % mesh window size
lambda = 0.005;    % regularization weight

maxIter = 200;   % maximum number of iterations at each hierarchical level
tol = 1e-5;    % tolerance (stopping criterion)
t0 = 1;       % initial step size for gradient descent
beta = 0.8;       % annealing rate on the optimization step    

dimen=size(refim);
M=ceil(dimen/2^(nscale-1));
[x, y]=meshgrid(1-spacing:spacing:M(2)+2*spacing, 1-spacing:spacing:M(1)+2*spacing);
[mg, ng]=size(x);
siz=[(mg-3)*spacing (ng-3)*spacing];

x = cat(3,x,y);  % Put x and y control point positions into a single mg x ng x 2 3Dmatrix
xgrid = x;  % save the regular grid (used for regularization to find the displacements)


tmp=zeros(2^(nscale-1)*siz);
tmp(1:dimen(1),1:dimen(2))=refim;  refim=tmp;
tmp(1:dimen(1),1:dimen(2))=im;     im=tmp;
clear tmp;

%% setup operators
bm = BsplineMotion2D('1', 0, spacing, [mg, ng]);
imsmall = ImResize(im, siz);
refimsmall = ImResize(refim, siz);
md = MotionDeformation2D({bm, imsmall});    

%% setup cost functions
ssd = SumSquaredDifference({md, refimsmall}, 1);
regLap = LaplacianRegularization(Minus({'1', '2'}), lambda, 2);

%% setup solver
param.beta = beta;
param.t0 = t0;
param.tol = tol;
param.maxIter = maxIter;
param.verbose = 2;
nlcg = NLCG({ssd, regLap}, param);

%% main loop
Xgrid = Variable.getVariable('2');
Xgrid.setInput(xgrid);
for level = 1 : nscale
    
    if level>1
        mg = 2 * mg - 3; % compute the new mesh size
        ng = 2 * ng - 3;
        siz=[(mg-3)*spacing (ng-3)*spacing];
        imsmall.siz = siz;
        refimsmall.siz = siz;
        bm.sizeNode = [mg, ng];  
    end

    x = nlcg.run(x);
    
    % if the sublevel is not last prepair for the next level
    if level < nscale
        x = upsamplingGrid(x, 1);
        xgrid = upsamplingGrid(xgrid, 1);
        Xgrid.setInput(xgrid);
    end
    
end

result = md.apply(x);

disp('MIRT: 2D B-spline based registration is succesfully completed.')

figure,imshow(refim); title('Reference (fixed) image');
figure,imshow(im);    title('Source (float) image');
figure,imshow(result); title('Registered (deformed) image');
