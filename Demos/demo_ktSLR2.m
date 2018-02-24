%% DEMO kt SLR 2
%
% This kt SLR problem (see demo kt SLR 1) can be rewritten as follows
%   
%   argmin 1/2 * ||UFx-d||^2 + mu1 * ||y||_Schatten + mu2 * ||z||_1,2
%   subject to y = x
%              z = Dx
%
% This problem can be solved by ALM solver.
%
% See also FouierTransformation, Gradient, Undersampling, SchattenNorm,
% SumSquaredDifference, L12Norm, ALM

% Reference:
% [1]Lingala, S. G., Hu, Y., Dibella, E., & Jacob, M. (2011). Accelerated 
% dynamic mri exploiting sparsity and low-rank structure: k-t slr. IEEE 
% Transactions on Medical Imaging, 30(5), 1042-1054.
%   
% Copyright 2018 Junshen Xu

clear all
close all

%% set parameters
p = 0.1; % parameter for Schatten p norm
mu = [1e-9, 1e-2]; % The continuation parameter for the Schatten p-norm and the TV norm.
beta = 25; % Continuation parmeter increment
maxIter = 50 * 3;
updateInterval = 50; % Continuation parmeter increment interval
tol = 1e-4;
% parameter for CG sub step
paramCG.maxIter = 30;
paramCG.tol = 1e-4;
paramCG.verbose = 0;

%% load data
load aperiodic_pincat.mat;
[n1,n2,n3]=size(new);
line = 24; % Number of radial rays per frame
mask = strucrand(n1,n2,n3,line); % Generate the (kx,ky)-t sampling pattern; Each frame has uniformly spaced radial rays, with random rotations across frames

%% setup operators
F = FourierTransform('1', 0, [1 2]);
E = Undersampling(F, 0, mask, false);
G = Gradient('1', 0, [1,2,3]);

%% get undersampled k-t data
kdata = E.apply(new);
x0 = E.adjoint(kdata); % zero filling reconstruction  

%% setup cost function
ssd = SumSquaredDifference({E, kdata}, 1);
nucNorm = SchattenNorm('2', 1, p, 2);
l12norm = L12Norm('3', 1, 3);

%% setup solver
eq1.lhs = {'1'};
eq1.rhs = {'2'};
eq2.lhs = {G};
eq2.rhs = {'3'};

param.maxIter = maxIter;
param.verbose = 2;
param.tol = tol;
param.updateInterval = updateInterval;
param.mu = mu;
param.beta = beta;
param.paramCG = paramCG;
param.plotFun = @(s)(imshow(imresize(abs(s.var{1}(:,:,24)),3), []));

alm = ALM({ssd, nucNorm, l12norm}, {eq1, eq2}, param);

%% run solver
x = alm.run({x0, x0, G.apply(x0)});
x = x{1};

%% show result
figure(1); colormap(gray);
subplot(2,3,1); imagesc(abs(new(:,:,24))); title('Gold standard, a spatial frame'); 
subplot(2,3,2); imagesc(abs(x0(:,:,24))); title('Direct IFFT, a spatial frame'); 
subplot(2,3,3); imagesc(abs(x(:,:,24))); title('k-t SLR, a spatial frame'); 
subplot(2,3,4); imagesc(abs(squeeze(new(60,:,:)))); title('Gold standard, image time profile'); 
subplot(2,3,5); imagesc(abs(squeeze(x0(60,:,:)))); title('Direct IFFT, image time profile'); 
subplot(2,3,6); imagesc(abs(squeeze(x(60,:,:)))); title('k-t SLR, image time profile'); 

