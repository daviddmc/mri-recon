%% DEMO Low-rank plus sparse MRI (Catesian sampling)
%
% This example solves the following problem:
%   
%   argmin_(L,S) 1/2 * ||UFC(L+S)-d||^2 + mu1 * ||L||_nuc + mu2 * ||TS||_1
%
% where L and S are the low-rank and sparse components of the MR image 
% repectively. d is undersampled k-space data, U is undersampling operator,
% F is Fourier transform, C is sensitivity map, T is Fourier transform 
% along temporal dimension. mu1 and mu2 are the regularization parameters.
%
% Note that the regularization term is the separable sum of functions of L 
% and S, so this problem can be solved with proximal gradient method.
%
% See also FourierTransformation, Undersampling, SensitivityMap,
% ReducedSum, NuclearNorm, SumSquaredDifference, L1Norm, PG
%
% Reference:
% [1]Otazo, R., Cand¨¨s, E., & Sodickson, D. K. (2015). Low©\rank plus 
% sparse matrix decomposition for accelerated dynamic mri with separation
% of background and dynamic components. Magnetic Resonance in Medicine, 
% 73(3), 1125-1136.
%   
% Copyright 2018 Junshen Xu

clear all
close all

%% set parameters
mu1 = 3;
mu2 = 0.01;

%% load data
load cardiac_perf_R8.mat;
[nx,ny,nt,nc]=size(kdata);

%% setup operators
A = ReduceSum([], 0, 4, 2, 0);
C = SensitivityMap(A, 0, b1, 1);
F = FourierTransform(C, 1, [1,2]);
E = Undersampling(F, 0, kdata(:,:,:,1) ~= 0, false);
timeF = FourierTransform([], 0, 3);

%% setup cost functions
ssd = SumSquaredDifference({E, kdata}, 1);
nucNorm = NuclearNorm([], mu1, 2);
l1norm = L1Norm(timeF, mu2);
lps = SeparableSum([], 1, {nucNorm, l1norm});

%% setup solver
param.maxIter = 50;
param.verbose = 2;
param.tol = 0.0025;
param.stopCriteria = 'PRIMAL_UPDATE';
pg = PG(ssd, lps, param);

%% run solver
x0 = E.adjoint(kdata);
x0(:,:,:,2) = 0;
x = pg.run(x0);

%% show results
L = x(:,:,:,1);
S = x(:,:,:,2);
LplusS = L + S;

selectedFrame = [2, 8, 14, 24];
ROIx = 33:96;
ROIy = 33:96;

for ii = 1 : length(selectedFrame)
    LplusSROI{ii} = LplusS(ROIx, ROIy, selectedFrame(ii));
    LROI{ii} = L(ROIx, ROIy, selectedFrame(ii));
    SROI{ii} = S(ROIx, ROIy, selectedFrame(ii));
end

LplusSROI = cat(2, LplusSROI{:});
SROI = cat(2, SROI{:});
LROI = cat(2, LROI{:});

r = max(abs(LplusSROI(:)));

figure;
subplot(3,1,1),imshow(abs(LplusSROI),[0,r]);ylabel('L+S')
subplot(3,1,2),imshow(abs(LROI),[0,r]);ylabel('L')
subplot(3,1,3),imshow(abs(SROI),[0,r]);ylabel('S')
