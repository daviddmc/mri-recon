%% DEMO Multi-scale Low Rank Matrix Decomposition
%
% This example solves the following matrix decomposition problem:
%   
%   argmin sum_i(lambda_i * ||x_i||_block_nuc)
%   subject to sum_i(x_i) = y
%
% where y is the original matrix, x_i blockwise low-rank components at 
% different scales, lambda_i are the weights for different scales.
%
% This problem can be by ADMM.
%
% See also BlockNuclearNorm, LinearEquation, SeparableSum, ADMM
%
% Reference:
% [1]Ong, F., & Lustig, M. (2016). Beyond low rank + sparse: multi-scale 
% low rank matrix decomposition. IEEE Journal of Selected Topics in Signal 
% Processing, 10(4), 672-687.
%   
% Copyright 2018 Junshen Xu

clear all
close all

%% load data
load('dce_mri');

%% Set Parameters

Y_size = size(Y); % Matrix Size


skip = 2;


% Plot
figure,imshow3(abs(Y)),title('Input','FontSize',14);
drawnow

%% Generate Multiscale block Sizes
L = ceil(max( log2( Y_size(1:2) ) ));
% Generate block sizes
block_sizes = [ min( 2.^(0:skip:L)', Y_size(1)) , min( 2.^(0:skip:L)', Y_size(2)), ones(length((0:skip:L)),1)*Y_size(3) ];

disp('Block sizes');
disp(block_sizes)

levels = size(block_sizes,1);
ms = prod(block_sizes(:,1:2),2);
ns = block_sizes(:,3);
bs = repmat( prod( Y_size(1:2) ), [levels,1]) ./ ms;

block_sizes = [ min( 2.^(0:skip:L)', Y_size(1)) , min( 2.^(0:skip:L)', Y_size(2)) ];

% Penalties
lambdas = sqrt(ms) + sqrt(ns) + sqrt( log2( bs .* min( ms, ns ) ) );

%% Initialize Operator
FOV = Y_size;
FOVl = [FOV,levels];
level_dim = length(FOV) + 1;

S = ReduceSum([], 0, level_dim, levels, false);
blockNuclearNorms = cell(1, levels);
for l = 1:levels
    blockNuclearNorms{l} = BlockNuclearNorm([], lambdas(l), block_sizes(l,:));
end
sumBlockNuclearNorms = SeparableSum([], 1, blockNuclearNorms);
DC = LinearEquation({S, Y});

param.maxIter = 1024; 
param.verbose = 2;
param.tol = 1e-3;
param.updateInterval = 3;
param.tau = 0.5;
param.gamma = 1;
param.plotFun = @(s)(imshow3(abs(s.var), []));
admm = ADMM(sumBlockNuclearNorms, [] ,DC, param);
X_it = admm.run(zeros(FOVl));


%% Show Result



