%% Multi-scale Low Rank Matrix Decomposition on Hanning Matrices
%
% (c) Frank Ong 2015
%
clc
clear
close all
%setPath

%% Set Parameters
N = 64; % Matrix length
L = log2(N);  % Number of levels
FOV = [N,N]; % Matrix Size
sigma = 0; % noise-less

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

S = ReduceSum([], 0, level_dim, levels, false);
blockNuclearNorms = cell(1, levels);
for l = 1:levels
    blockNuclearNorms{l} = BlockNuclearNorm([], lambdas(l), block_sizes(l,:));
end
sumBlockNuclearNorms = SeparableSum([], 1, blockNuclearNorms);
DC = LinearEquation({S, X});

param.maxIter = nIter;
param.verbose = 2;
param.rho0 = 10;
param.tol = 1e-3;

[X_it, info ] = ADMM(DC, sumBlockNuclearNorms, [], zeros(FOVl), param );
%% Show Result

figure,imshow3(abs(X_it),[],[1,levels]),title('Multi-scale Low Rank Decomposition','FontSize',14);


