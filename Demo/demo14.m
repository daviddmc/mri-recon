clear all
close all

load brain.mat

ft = FourierTransformation('1', 0, [1 2]);
E = Undersampling(ft, 0, mask_vardens, 0);
%E = mask * ft;
kdata = E.apply(im);

wt = WaveletTransformation('1', 0, 'Daubechies',4,4);

ssd = SumSquaredDifference({E, kdata}, 1);

lambda = 0.025/2;
l1norm = L1Norm('2', lambda);

eq1.lhs = {wt};
eq1.rhs = {'2'};

x0 = ft.adjoint(kdata ./ pdf_vardens);
x0 = {x0, wt.apply(x0)};

alm = ALM({ssd, l1norm}, {eq1});

param.maxIter = 15;
param.verbose = 2;
param.mu = 1;
param.stopCriteria = 'MAX_ITERATION';
[x, info] = alm.run(x0, param);


imshow(abs(x{1}),[])

