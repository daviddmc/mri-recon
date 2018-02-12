clear all
close all

load brain512.mat

ft = FourierTransformation([], 0, [1 2]);
E = Undersampling(ft, 0, mask, false);
%E = M * ft;

im_dc = E.adjoint(data .* mask ./ pdf);
data = data.*mask/max(abs(im_dc(:)));
im_dc = im_dc/max(abs(im_dc(:)));

wt = WaveletTransformation([], 0, 'Daubechies',4,4);

%ssd = SumSquaredDifference(E, data, 1);
ssd = SumSquaredDifference({[], data}, 1);

l1norm = L1Norm([], 0.01);
l1tv = L1Norm([], 0.005);
G = Gradient([], 0, [1,2], []);
%option.maxIter = 50;
%option.tol = 1e-3;
%tv = TotalVariation([1, 2], 'anisotropic', [], 0.005, option);

x0 = im_dc;

param.maxIter = 40;
param.verbose = 2;

%[ x, info] = FBPD( tv, l1norm, wt, ssd, x0, param );
[x, info] = NLCG({ssd, l1norm, l1tv}, {E, wt, G}, x0, param);

