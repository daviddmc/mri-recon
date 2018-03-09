%% DEMO Compressed Sensing MRI 2
%
% This example solves the following problem:
%   
%   argmin 1/2 * ||UFx-d||^2 + mu1 * TV(x) + mu2 * ||Wx||_1
%
% i.e., it combines the two regularization term in demo_CS1. This problem
% can be solved with a forward-backward primal-dual solver.
%
% Note that the TV semi-norm can be written as
%
%   TV(x) = ||Dx||_1
%
% where D is the gradient operator. The original problem becomes
%   
%   argmin 1/2 * ||UFx-d||^2 + mu1 * ||Dx||_1 + mu2 * ||Wx||_1
%
% This can be solved with non-linear conjugate gradient method.
%
% See also FourierTransformation, Undersampling, WaveletTransformation, 
% SumSquaredDifference, Gradient, L1Norm, TotalVariation, FBPD, NLCG

% Copyright 2017 Junshen Xu

clear all
close all

%% set paramters
mu1 = 0.0005;
mu2 = 0.001;
method = 1; % 0 for FBPD and 1 for NLCG

%% load data
load brain.mat

%% setup operators
ft = FourierTransform([], 0, [1 2]);
E = Undersampling(ft, 0, mask_vardens, 0);
wt = WaveletTransform([], 0, 'Daubechies',4,4);

%% get undersampled data
data = E.apply(im); % get undersampling k-space data
im_zf = E.adjoint(data ./ pdf_vardens); % zero filling reconstruction with compansation for variable density in k-space sampling
% normalize data and image
data = data / max(abs(im_zf(:)));
im_zf = im_zf / max(abs(im_zf(:)));

%% setup cost functions
ssd = SumSquaredDifference({E, data}, 1);
if method
    G = Gradient([], 0, [1,2]);
    tv = L1Norm(G, mu1);
    l1norm = L1Norm(wt, mu2);
else
    option.maxIter = 50;
    option.tol = 1e-3;
    option.dim = [1,2];
    option.type = 'anisotropic';
    tv = TotalVariation([], mu1, option);
    l1norm = L1Norm([], mu2);
end

%% setup solver
param.maxIter = 30;
param.verbose = 2;
param.tol = 1e-3;
if method
    solver = NLCG({ssd, tv, l1norm}, param);
else
    solver = FBPD(tv, l1norm, wt, ssd, param);
end

%% run solver
[x, info] = solver.run(im_zf);

%% show result
subplot(1,3,1),imshow(abs(im_zf), []);
title('zero filling')
subplot(1,3,2),imshow(abs(x), []);
title('TV + Wavelet compressed sensing')
subplot(1,3,3),imshow(abs(im), []);
title('ground truth')


