function [x,f1] = fnlCg_SENSE3D(x0,params)
%-----------------------------------------------------------------------
%
% res = fnlCg(x0,params)
%
% implementation of a L1 penalized non linear conjugate gradient reconstruction
%
% The function solves the following problem:
%
% given k-space measurments y, and a fourier operator F the function 
% finds the image x that minimizes:
%
% Phi(x) = ||F* C *x - y||^2 + lambda1*|x|_1 + lambda2*TV(W'*x) 
%
%
% the optimization method used is non linear conjugate gradient with fast&cheap backtracking
% line-search.
% 
% (c) Michael Lustig 2007
%
%
% Additional inputs:
%   params.sens : sensitivity maps, with size [im_size_x, im_size_y, num_coils]
%
%-------------------------------------------------------------------------
x = x0;



% line search parameters
maxlsiter = params.lineSearchItnlim ;
gradToll = params.gradToll ;
alpha = params.lineSearchAlpha; 
beta = params.lineSearchBeta;
t0 = params.lineSearchT0;
k = 0;
t = 1;

% copmute g0  = grad(Phi(x))

g0 = wGradient(x,params);

dx = -g0;


% iterations
while(1)

% backtracking line-search

	% pre-calculate values, such that it would be cheap to compute the objective
	% many times for efficient line-search
	[FTXFMtx, FTXFMtdx, DXFMtx, DXFMtdx] = preobjective(x, dx, params);
	f0 = objective(FTXFMtx, FTXFMtdx, DXFMtx, DXFMtdx,x,dx, 0, params);
	t = t0;
        [f1, ERRobj]  =  objective(FTXFMtx, FTXFMtdx, DXFMtx, DXFMtdx,x,dx, t, params);
	
	lsiter = 0;

	while (f1 > f0 - alpha*t*abs(g0(:)'*dx(:)))^2 & (lsiter<maxlsiter)
		lsiter = lsiter + 1;
		t = t * beta;
		[f1, ERRobj]  =  objective(FTXFMtx, FTXFMtdx, DXFMtx, DXFMtdx,x,dx, t, params);
	end

	if lsiter == maxlsiter
		disp('Reached max line search,.... not so good... might have a bug in operators. exiting... ');
		return;
	end

	% control the number of line searches by adapting the initial step search
	if lsiter > 2
		t0 = t0 * beta;
	end 
	
	if lsiter<1
		t0 = t0 / beta;
	end

	x = (x + t*dx);

	%--------- uncomment for debug purposes ------------------------
%     if mod(k,1) == 0 && (k > 0)
%     	disp(sprintf('%d   , obj: %f, L-S: %d', k,f1,lsiter));
%     end
	%---------------------------------------------------------------
	
    %conjugate gradient calculation
    
	g1 = wGradient(x,params);
	bk = g1(:)'*g1(:)/(g0(:)'*g0(:)+eps);
	g0 = g1;
	dx =  - g1 + bk* dx;
	k = k + 1;
	
	%TODO: need to "think" of a "better" stopping criteria ;-)
	if (k > params.Itnlim) | (norm(dx(:)) < gradToll) 
		break;
	end

end


return;


% -------------------------------------------------------------------------
function [FCtx, FCtdx, DXFMtx, DXFMtdx] = preobjective(x, dx, params)
% precalculates transforms to make line search cheap

tx = params.XFM'*x;
tdx = params.XFM'*dx;

FCtx = [];
FCtdx = [];

for coil = 1:params.num_coils
    FCtx{coil} = params.FT * (params.sens{coil} .* tx);
    FCtdx{coil} = params.FT * (params.sens{coil} .* tdx);
%     FCtx{coil} = params.FT * bsxfun(@times, tx, params.sens{coil});
%     FCtdx{coil} = params.FT * bsxfun(@times, tdx, params.sens{coil});
end 


if params.TVWeight
    DXFMtx = params.TV*(tx);
    DXFMtdx = params.TV*(tdx);
else
    DXFMtx = 0;
    DXFMtdx = 0;
end
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
function [res, obj] = objective(FCtx, FCtdx, DXFMtx, DXFMtdx, x,dx,t, params)
%calculates the objective function

p = params.pNorm;

obj = 0;
for coil = 1:params.num_coils
    temp = FCtx{coil} + t * FCtdx{coil} - params.data{coil};
    obj = obj + norm(temp(:))^2;
end


if params.TVWeight
    w = DXFMtx(:) + t*DXFMtdx(:);
    TV = (w.*conj(w)+params.l1Smooth).^(p/2); 
else
    TV = 0;
end

if params.xfmWeight
   w = x(:) + t*dx(:); 
   XFM = (w.*conj(w)+params.l1Smooth).^(p/2);
else
    XFM=0;
end


TV = sum(TV.*params.TVWeight(:));
XFM = sum(XFM.*params.xfmWeight(:));

res = obj + (TV) + (XFM) ;
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
function grad = wGradient(x,params)

gradXFM = 0;
gradTV = 0;

gradObj = gOBJ(x,params);
if params.xfmWeight
gradXFM = gXFM(x,params);
end
if params.TVWeight
gradTV = gTV(x,params);
end


grad = (gradObj +  params.xfmWeight.*gradXFM + params.TVWeight.*gradTV);
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
function gradObj = gOBJ(x,params)
% computes the gradient of the data consistency

tx = params.XFM'*x;
temp = 0;

for coil = 1:params.num_coils
    Res = params.FT * (params.sens{coil} .* tx) - params.data{coil};
    temp = temp + conj(params.sens{coil}) .* (params.FT'*Res);
%     Res = params.FT * bsxfun(@times, tx, params.sens{coil}) - params.data{coil};
%     temp = temp + bsxfun(@times, params.FT'*Res, conj(params.sens{coil}));
end

gradObj = params.XFM*temp;
gradObj = 2*gradObj;

% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
function grad = gXFM(x,params)
% compute gradient of the L1 transform operator

p = params.pNorm;

grad = p*x.*(x.*conj(x)+params.l1Smooth).^(p/2-1);
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
function grad = gTV(x,params)
% computes gradient of TV operator

p = params.pNorm;

Dx = params.TV*(params.XFM'*x);

G = p*Dx.*(Dx.*conj(Dx) + params.l1Smooth).^(p/2-1);
grad = params.XFM*(params.TV'*G);
% -------------------------------------------------------------------------
