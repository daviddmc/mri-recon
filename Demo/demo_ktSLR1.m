%% DEMO kt SLR 1
%
% This example reconstructd dynamic MRI exploiting sparsity and low-rank 
% structure. The problem is 
%   
%   argmin 1/2 * ||UFx-d||^2 + mu1 * ||x||_Schatten + mu2 * TV(x)
%
% where x is the unknown dynamic MR images, U is Fourier transform, U is 
% undersampling operator, d is the sampled k-t space data, TVt is the 
% spatial temporal total variation, mu1 and mu2 are the regularization 
% parameters.
%
% The TV regularization can be written as
%
%   TV(x) = ||Dx||_1,2
%
% where D is the spatial temporal gradient operator. We can solve this 
% problem with FBPD solver.
%
% See also FouierTransformation, Gradient, Undersampling, 
% SumSquaredDifference, L12Norm, NuclearNor, FBPD

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
mu1 = 1.5e4; % Schatten p norm
mu2 = 1.5;

%% load data
load aperiodic_pincat.mat;
[n1,n2,n3]=size(new);
line = 24; % Number of radial rays per frame
mask = strucrand(n1,n2,n3,line); % Generate the (kx,ky)-t sampling pattern; Each frame has uniformly spaced radial rays, with random rotations across frames

%% setup operators
F = FourierTransformation([], 0, [1 2]);
E = Undersampling(F, 0, mask, false);
G = Gradient([], 0, [1,2,3]);

%% get undersampled k-t data
kdata = E.apply(new);
x0 = E.adjoint(kdata); % zero filling reconstruction  

%% setup cost function
ssd = SumSquaredDifference({E, kdata}, 1);
nucNorm = SchattenNorm([], mu1, p, 2);
l12norm = L12Norm([], mu2, 3);

%% setup solver
fbpd = FBPD(nucNorm, l12norm, G, ssd);

%% run solver
param.maxIter = 100;
param.verbose = 2;
param.stopCriteria = 'PRIMAL_UPDATE';
param.tol = 1e-3;
x = fbpd.run(x0, param);

%% show result
figure(1); colormap(gray);
subplot(2,3,1); imagesc(abs(new(:,:,24))); title('Gold standard, a spatial frame'); 
subplot(2,3,2); imagesc(abs(x0(:,:,24))); title('Direct IFFT, a spatial frame'); 
subplot(2,3,3); imagesc(abs(x(:,:,24))); title('k-t SLR, a spatial frame'); 
subplot(2,3,4); imagesc(abs(squeeze(new(60,:,:)))); title('Gold standard, image time profile'); 
subplot(2,3,5); imagesc(abs(squeeze(x0(60,:,:)))); title('Direct IFFT, image time profile'); 
subplot(2,3,6); imagesc(abs(squeeze(x(60,:,:)))); title('k-t SLR, image time profile'); 

