%% demo BCS


clear all
close all

%% set parameter
p = 0.5;
r = 40;
lambda = 1;
mu = [0.12, 12, 1, 10];
%beta = [1,1, 100, 5];
%mu = 1;
beta = 2;
updateInterval = 15;
maxIter = 100;

%% load data
load data.mat
img1 = permute(img1, [1,2,4,3]);
im_gt = squeeze(rssq(img1, 4));  % fully sampled coil combined data
[nx,ny,nt,nc] = size(img1);       % dimensions of the image

m=nx*ny;
n=nt;

samp = fftshift(fftshift(samp(:,:,1:nt), 1), 2);
samp = repmat(samp,[1 1 1 nc]);

csm = permute(csm, [1,2,4,3]);

%% setup operators
R = Reshape('6', [m, n], [nx, ny, nt]);
S = SensitivityMap(R, 0, csm, false);
F = FourierTransform('5', 0, [1,2]);
P = Undersampling(F, 0, samp, false);
M = MatrixMultiplication({'2', '4'});

kdata = P.apply(img1) * 128;

%% setup cost function
lpNorm = LpNorm('1', lambda, p);
l2Ball = L2Ball('3', 1);
ssd = SumSquaredDifference({P, kdata}, 1);

%% setup constrain
eq1.lhs = {'6'};
eq1.rhs = {M};
eq2.lhs = {S};
eq2.rhs = {'5'};
eq3.lhs = {'2'};
eq3.rhs = {'1'};
eq4.lhs = {'3'};
eq4.rhs = {'4'};

%% init
Z = P.adjoint(kdata);
X = S.adjoint(Z);
U = zeros(r,m); % Coefficients    
V = rand(r,n);  % Randon initialization for the dictionary V
L = U;
Q = V;

%% setup solver

param.mu = mu;
param.beta = beta;
param.updateInterval = updateInterval;
param.maxIter = maxIter;
param.verbose = 2;
param.plotFun = @plotfun;

alm = ALM({ssd, lpNorm, l2Ball}, {eq1, eq2, eq3, eq4}, param);

%% run solver
sol = alm.run({L, U, Q, V, Z, X});
[L, U, Q, V, Z, X] = sol{:};
