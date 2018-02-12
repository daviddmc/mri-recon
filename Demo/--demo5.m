clear all
close all


load aperiodic_pincat.mat; % load the PINCAT phantom
[n1,n2,n3]=size(new);
line = 24; % Number of radial rays per frame
mask = strucrand(n1,n2,n3,line); % Generate the (kx,ky)-t sampling pattern; Each frame has uniformly spaced radial rays, with random rotations across frames

F = FourierTransformation([], 0, [1 2]);
E = Undersampling(F, 0, mask, false);

kdata = E.apply(new);
x0 = E.adjoint(kdata);

ssd = SumSquaredDifference({E, kdata}, 1e-4);

nucNorm = NuclearNorm([], 0.1, 2);

%option.maxIter = 50;
%option.tol = 1e-3;
%option.weight = [1, 1, 3];
%tv = TotalVariation([1, 2, 3], 'anisotropic', [], 1e-1, option);
G = Gradient([], 0, [1,2,3], [1,1,3]);
l1norm = L1Norm([], 1e-4);

param.maxIter = 50;
param.verbose = 2;
[ x, info] = FBPD( nucNorm, l1norm, G, ssd, x0, param );
%[ x, info] = FBFPD( nucNorm, l1norm, G, ssd, x0, param );
%[ x, info ] = FBFPD( nucNorm, tv, [], ssd, x0, param );

