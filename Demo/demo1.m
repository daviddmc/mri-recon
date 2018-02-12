clear all
close all

load brain.mat

ft = FourierTransformation([], 0, [1 2]);
E = Undersampling(ft, 0, mask_vardens, 0);
%E = mask * ft;
kdata = E.apply(im);

wt = WaveletTransformation([], 0, 'Daubechies',4,4);

ssd = SumSquaredDifference({E, kdata}, 1);

lambda = 0.025/2;
l1norm = L1Norm(wt, lambda);

%option.maxIter = 30;
%option.tol = 1e-3;
%tv = TotalVariation([1, 2], 'isotropic', [], 0.1, option);

x0 = ft.adjoint(kdata ./ pdf_vardens);

param.maxIter = 15;
param.verbose = 2;
param.stopCriteria = 'MAX_ITERATION';

pg = PG(ssd, l1norm);
[x, info] = pg.run(x0, param);

%[x info] = PG( ssd, l1norm, x0, param );
imshow(abs(x),[])

