clear all
close all

load cardiac_perf_R8.mat;

[nx,ny,nt,nc]=size(kdata);
A = ReduceSum([], 0, 4, 2, 0);
S = SensitivityMap(A, 0, b1);
F = FourierTransformation(S, 1, [1,2]);
E = Undersampling(F, 0, kdata(:,:,:,1) ~= 0, false);

%M = Mask(kdata(:,:,:,1) ~= 0, false);
%F = FourierTransformation([1 2])';
%S = SensitivityMap(b1);
%A = Sum(4, 2, false);
%E = M * F * S * A;
x0 = E.adjoint(kdata);
x0(:,:,:,2) = 0;

ssd = SumSquaredDifference({E, kdata}, 1);

timeF = FourierTransformation([], 0, 3);
l1norm = L1Norm(timeF, 0.05);%0.05

%option.maxIter = 10;
%option.tol = 1e-3;
%tv = TotalVariation(3,'isotropic', [], 0.5, option);
%nucNorm = NuclearNorm([], 2, 2);

option.maxIter = 1;
option.type = 0;
nucNorm = NuclearNorm([], 3, 2, 1, option); %3 dim=2
lps = SeparableSum([], 1, {nucNorm, l1norm});


%lps = SeparableSum(1, nucNorm, tv);

param.maxIter = 40;
param.verbose = 2;
[ x, info] = PG(ssd, lps, x0, param );

x = x{1};
L = x(:,:,:,1);
S = x(:,:,:,2);
LplusS=L+S;

LplusSd=LplusS(33:96,33:96,2);LplusSd=cat(2,LplusSd,LplusS(33:96,33:96,8));LplusSd=cat(2,LplusSd,LplusS(33:96,33:96,14));LplusSd=cat(2,LplusSd,LplusS(33:96,33:96,24));
Ld=L(33:96,33:96,2);Ld=cat(2,Ld,L(33:96,33:96,8));Ld=cat(2,Ld,L(33:96,33:96,14));Ld=cat(2,Ld,L(33:96,33:96,24));
Sd=S(33:96,33:96,2);Sd=cat(2,Sd,S(33:96,33:96,8));Sd=cat(2,Sd,S(33:96,33:96,14));Sd=cat(2,Sd,S(33:96,33:96,24));

figure;
subplot(3,1,1),imshow(abs(LplusSd),[0,1]);ylabel('L+S')
subplot(3,1,2),imshow(abs(Ld),[0,1]);ylabel('L')
subplot(3,1,3),imshow(abs(Sd),[0,1]);ylabel('S')
