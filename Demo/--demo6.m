clear all
close all

load aperiodic_pincat.mat; % load the PINCAT phantom
[n1,n2,n3]=size(new);
line = 24; % Number of radial rays per frame
mask = strucrand(n1,n2,n3,line); % Generate the (kx,ky)-t sampling pattern; Each frame has uniformly spaced radial rays, with random rotations across frames

F = FourierTransformation([1 2]);
M = Mask(mask, false);
A = Sum(4, 2, false);
E = M * F;
kdata = E.apply(new);
E = E * A;
ssd = SumSquaredDifference(E, kdata, 1);

x0 = E.adjoint(kdata);
x0(:,:,:,2) = 0;

timeF = FourierTransformation(3);
l1norm = L1Norm(timeF, 0.000001);

nucNorm = NuclearNorm([], 0.5, 2);

lps = SeparableSum(1, nucNorm, l1norm);

param.maxIter = 40;
param.verbose = 2;

[ x, info] = ProximalGradient(ssd, lps, x0, param );

L = x(:,:,:,1);
S = x(:,:,:,2);
LplusS=L+S;

LplusSd=LplusS(:,:,2);
LplusSd=cat(2,LplusSd,LplusS(:,:,8));
LplusSd=cat(2,LplusSd,LplusS(:,:,14));
LplusSd=cat(2,LplusSd,LplusS(:,:,24));
Ld=L(:,:,2);
Ld=cat(2,Ld,L(:,:,8));
Ld=cat(2,Ld,L(:,:,14));
Ld=cat(2,Ld,L(:,:,24));
Sd=S(:,:,2);
Sd=cat(2,Sd,S(:,:,8));
Sd=cat(2,Sd,S(:,:,14));
Sd=cat(2,Sd,S(:,:,24));

figure;
subplot(3,1,1),imshow(abs(LplusSd),[]);ylabel('L+S')
subplot(3,1,2),imshow(abs(Ld),[]);ylabel('L')
subplot(3,1,3),imshow(abs(Sd),[]);ylabel('S')