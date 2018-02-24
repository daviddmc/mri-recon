%% DEMO Golden-angle RAdial Sparse Parallel MRI (GRASP)
%
% This example solves the following problem:
%   
%   argmin 1/2 * ||Ex-d||^2 + mu * TVt(x)
%
% where x is the unknown dynamic MR images, E is the NUFFT imaging
% operator, d is golden-angle radial sampled k-space data, TVt is the total
% variation along time axis and mu is the regularization parameters.
%
% The TV regularization can be written as
%
%   TVt(x) = ||Dx||_1
%
% where D is the gradient operator along time axis. We can solve this 
% problem with non-linear conjugate gradient method.
%
% See also NUFT, Gradient, SensitivityMap, SumSquaredDifference, L1Norm, 
% NLCG

% Reference:
% [1]Feng, L., Grimm, R., Block, K. T., Chandarana, H., Kim, S., & Xu, J., 
% et al. (2014). Golden-angle radial sparse parallel mri: combination of 
% compressed sensing, parallel imaging, and golden-angle radial sampling 
% for fast and flexible dynamic volumetric mri. Magnetic Resonance in 
% Medicine, 72(3), 707-717.
%   
% Copyright 2018 Junshen Xu

clear all;
close all;

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
E = NUFT([], 0, [size(b1,1), size(b1,2)], nt, nc, ku, wu, b1);
G = Gradient([], 0, 3, []);

%% setup functions
recon_nufft = E.adjoint(kdatau); % nufft reconstruction
kdatau = kdatau / max(abs(recon_nufft(:)));
recon_nufft = recon_nufft / max(abs(recon_nufft(:)));
l1norm = L1Norm(G,  0.25);
ssd = SumSquaredDifference({E, kdatau}, 1);

%% setup solver
param.maxIter = 20;
param.verbose = 2;
param.tol = 1e-3;
param.alpha = 0.01;  
param.beta = 0.6;
nlcg = NLCG({ssd, l1norm}, param);

%% run solver
recon_cs = nlcg.run(recon_nufft);

%% show results
selectedFrame = [1, 7, 13, 23];
for ii = 1 : length(selectedFrame)
    recon_nufft_show{ii} = recon_nufft(:,:,selectedFrame(ii));
    recon_cs_show{ii} = recon_cs(:,:,selectedFrame(ii));
end
recon_nufft_show = cat(2, recon_nufft_show{:});
recon_cs_show = cat(2, recon_cs_show{:});

figure;
subplot(2,1,1),imshow(abs(recon_nufft_show),[]);title('Zero-filled FFT')
subplot(2,1,2),imshow(abs(recon_cs_show),[]);title('GRASP')
