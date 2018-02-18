%% DEMO Compressed Sensing MRI 3
%
% Recall that the problem we deal with in demo CS2 is 
%   
%   argmin 1/2 * ||UFx-d||^2 + mu1 * ||Dx||_1 + mu2 * ||Wx||_1
%
% We can spliting the unknown variable by adding new constrain
%
%   argmin 1/2 * ||UFx-d||^2 + mu1 * ||y||_1 + mu2 * ||z||_1
%   subject to Dx = y
%              Wx = z
%
% This problem can be solved by augmented Lagrangian method
%
% See also FourierTransformation, Undersampling, WaveletTransformation, 
% SumSquaredDifference, Gradient, L1Norm, ALM

% Reference:
% [1]Goldstein, T., & Osher, S. (2009). The Split Bregman Method for 
% L1-Regularized Problems. Society for Industrial and Applied Mathematics.
%
% Copyright 2018 Junshen Xu

clear all
close all

%% set paramters
mu1 = 0.025;
mu2 = 0.05;

%% load data
load brain.mat

%% setup operators
ft = FourierTransformation('1', 0, [1 2]);
E = Undersampling(ft, 0, mask_vardens, 0);
wt = WaveletTransformation('1', 0, 'Daubechies',4,4);

%% get undersampled data
data = E.apply(im); % get undersampling k-space data
im_zf = E.adjoint(data ./ pdf_vardens); % zero filling reconstruction with compansation for variable density in k-space sampling
% normalize data and image
data = data / max(abs(im_zf(:)));
im_zf = im_zf / max(abs(im_zf(:)));

%% setup cost functions
ssd = SumSquaredDifference({E, data}, 1);
G = Gradient('1', 0, [1,2]);
tv = L1Norm('2', mu1);
l1norm = L1Norm('3', mu2);

%% setup solver
eq1.lhs = {G};
eq1.rhs = {'2'};
eq2.lhs = {wt};
eq2.rhs = {'3'};
solver = ALM({ssd, tv, l1norm}, {eq1, eq2});

%% run solver
param.maxIter = 50;
param.verbose = 2;
param.tol = 1e-3;
param.beta = 1.1;
[x, info] = solver.run({im_zf, G.apply(im_zf), wt.apply(im_zf)}, param);

%% show result
subplot(1,3,1),imshow(abs(im_zf), []);
title('zero filling')
subplot(1,3,2),imshow(abs(x{1}), []);
title('TV + Wavelet compressed sensing')
subplot(1,3,3),imshow(abs(im), []);
title('ground truth')
