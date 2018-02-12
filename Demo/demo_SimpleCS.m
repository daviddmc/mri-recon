%% DEMO Compressed Sensing MRI
%
% This example solves the following problem:
%   
%   argmin 1/2 * ||UFx-d||^2 + mu * R(x)
%
% where x is the unknown MR image, d is undersampled k-space data, U is
% undersampling operator, F is Fourier transform, R is the regularization 
% term, and mu is the regularization parameter.
%
% In compressed sensing, R is often chosen to be sparsifying
% regularization, such as L1 norm and total variation.
%
% In this demo, we solve this problem with proximal gradient method.
%
% See also FourierTransformation, Undersampling, WaveletTransformation, 
% SumSquaredDifference, TotalVariation, L1Norm, PG

% Copyright 2017 Junshen Xu

clear all
close all

%% set paramters
regType = 0; % 0 for L1 norm and 1 for total variation
mu = 0.025/2; % regularization parameter

%% load data
load brain.mat

%% setup operators
ft = FourierTransformation([], 0, [1 2]);
E = Undersampling(ft, 0, mask_vardens, 0);
wt = WaveletTransformation([], 0, 'Daubechies',4,4);
kdata = E.apply(im); % get k-space data

%% setup cost functions
ssd = SumSquaredDifference({E, kdata}, 1);

if regType % choose regularization term
    option.maxIter = 10;
    option.tol = 1e-3;
    R = TotalVariation([], mu, [1, 2], 'isotropic', option);
else
    R = L1Norm(wt, mu);
end

%% setup solver
param.maxIter = 15;
param.verbose = 2;
param.stopCriteria = 'MAX_ITERATION';
pg = PG(ssd, R);
x0 = ft.adjoint(kdata ./ pdf_vardens);

[x, info] = pg.run(x0, param);

%% show result
subplot(1,2,1),imshow(abs(x0), []);
title('zero filling')
subplot(1,2,2),imshow(abs(x), []);
if regType
    title('TV compressed sensing')
else
    title('L1 compressed sensing')
end

