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

%% Set Parameters
N = 64; % Matrix length
L = log2(N);  % Number of levels
FOV = [N,N]; % Matrix Size

nIter = 50; % Number of iterations

rho = 10; % ADMM parameter


%% Generate Multiscale block Sizes
max_L = L;

% Generate block sizes
block_sizes = [2.^(0:2:max_L)', 2.^(0:2:max_L)'];
disp('Block sizes:');
disp(block_sizes)

levels = size(block_sizes,1);

ms = block_sizes(:,1);

ns = block_sizes(:,2);

bs = prod( repmat(FOV, [levels,1]) ./ block_sizes, 2 );

% Penalties
lambdas = sqrt(ms) + sqrt(ns) + sqrt( log2( bs .* min( ms, ns ) ) );


%% Generate Hanning Blocks

rng(5)
nblocks = [10, 6, 4, 1];

[X, X_decom] = gen_hanning( FOV, block_sizes, nblocks, sigma );

figure,imageShow(abs(X),[])
%titlef('Input');

figure,imshow3(abs(X_decom),[],[1,levels]),
%titlef('Actual Decomposition');
drawnow

%% Initialize Operator

FOVl = [FOV,levels];
level_dim = length(FOV) + 1;

S = ReduceSum('1', 0, level_dim, levels, false);
blockNuclearNorms = cell(1, levels);
for l = 1:levels
    blockNuclearNorms{l} = BlockNuclearNorm('2', lambdas(l), block_sizes(l,:));
end
sumBlockNuclearNorms = SeparableSum(blockNuclearNorms, 1);
DC = LinearEquation({S, X});

param.maxIter = nIter; 
param.verbose = 2;
param.tol = 1e-3;
param.updateInterval = 3;
param.tau = 1;
param.gamma = 1.5;
admm = ADMM(sumBlockNuclearNorms, [] ,DC);
X_it = admm.run(zeros(FOVl), param);

%% Show Result

figure,imshow3(abs(X_it),[],[1,levels]),title('Multi-scale Low Rank Decomposition','FontSize',14);


