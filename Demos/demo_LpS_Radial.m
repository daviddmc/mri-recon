%% DEMO Low-rank plus sparse MRI (Golden-angle Radial sampling)
%
% This example solves the following problem:
%   
%   argmin_(L,S) 1/2 * ||E(L+S)-d||^2 + mu1 * ||L||_nuc + mu2 * TVt(S)
%
% where L and S are the low-rank and sparse components of the MR image 
% repectively. d is radial sampled k-space data, E is the NUFFT operator, 
% mu1 and mu2 are the regularization parameters.
%
% For more infomation, see demo_LpS_Cartesian.
%
% See also NUFFT, TotalVariation, SumSquaredDifference, ReducedSum, 
% SeparableSum, PG
%
% Reference:
% [1]Otazo, R., Cand¨¨s, E., & Sodickson, D. K. (2015). Low-rank plus 
% sparse matrix decomposition for accelerated dynamic mri with separation
% of background and dynamic components. Magnetic Resonance in Medicine, 
% 73(3), 1125-1136.
%   
% Copyright 2018 Junshen Xu

clear all;
close all;

%% set parameters
mu1 = 25;
mu2 = 20;

%% load data
load liver_data.mat
[nx, ntviews, nc]=size(kdata);
nspokes = 21; % number of spokes per frame
nt = floor(ntviews/nspokes); % number of frames
b1 = b1 / max(abs(b1(:)));
% density compenstate
for ch = 1 : nc
    kdata(:,:,ch) = kdata(:,:,ch) .* sqrt(w);
end
% crop the data according to the number of spokes per frame
kdata = kdata(:,1:nt*nspokes,:);
k = k(:,1:nt*nspokes);
w = w(:,1:nt*nspokes);
% sort the data into a time-series
for ii=1:nt
    kdatau(:,:,:,ii) = kdata(:,(ii-1)*nspokes+1:ii*nspokes,:);
    ku(:,:,ii) = k(:,(ii-1)*nspokes+1:ii*nspokes);
    wu(:,:,ii) = w(:,(ii-1)*nspokes+1:ii*nspokes);
end

%% setup operators
A = ReduceSum([], 0, 4, 2, 0);
E = NUFT(A, 0, [size(b1,1), size(b1,2)], nt, nc, ku, wu, b1);

%% setup functions
recon_nufft = E.adjoint(kdatau); % nufft reconstruction
kdatau = kdatau / max(abs(recon_nufft(:)));
recon_nufft = recon_nufft / max(abs(recon_nufft(:)));

ssd = SumSquaredDifference({E, kdatau}, 1);
nucNorm = NuclearNorm([], mu1, 2);
option.maxIter = 5;
option.tol = 1e-3;
option.type = 'isotropic';
option.dim = 3;
TVt = TotalVariation([], mu2, option);
lps = SeparableSum([], 1, {nucNorm, TVt});

%% setup solver
param.maxIter = 50;
param.verbose = 2;
param.tol = 0.0025;
param.stopCriteria = 'PRIMAL_UPDATE';
pg = PG(ssd, lps, param);

%% run solver
x = pg.run(recon_nufft);

%% show results
L = x(:,:,:,1);
S = x(:,:,:,2);
LplusS = L + S;

selectedFrame = [2, 8, 14, 24];
ROIx = 33:96;
ROIy = 33:96;

for ii = 1 : length(selectedFrame)
    LplusSROI{ii} = LplusS(:, :, selectedFrame(ii));
    LROI{ii} = L(:, :, selectedFrame(ii));
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
