function [x,flag,relres,iter,resvec,lsvec] = lsqr(A,b,tol,maxit,M1,M2,x0)

    
m = size(b,1);
tol = 1e-6;
maxit = 20;

n = size(x0,1);
x = x0;
xInit = true;

% Set up for the method
n2b = norm(b);                     % Norm of rhs vector, b
flag = 1;
tolb = tol * n2b;                  % Relative tolerance
u = b;
if xInit
    u = u - iterapp('mtimes',afun,atype,afcnstr,x,varargin{:},'notransp');
end
beta = norm(u);
% Norm of residual r=b-A*x is estimated well by prod_i abs(sin_i)
normr = beta;
if beta ~= 0
    u = u / beta;
end
c = 1;
s = 0;
phibar = beta;
v = iterapp('mtimes',afun,atype,afcnstr,u,varargin{:},'transp');

alpha = norm(v);
if alpha ~= 0
    v = v / alpha;
end
d = zeros(n,1);

% norm((A*inv(M))'*r) = alpha_i * abs(sin_i * phi_i)
normar = alpha * beta;


% Poorly estimate norm(A*inv(M),'fro') by norm(B_{ii+1,ii},'fro')
% which is in turn estimated very well by
% sqrt(sum_i (alpha_i^2 + beta_{ii+1}^2))
norma = 0;
% norm(inv(A*inv(M)),'fro') = norm(D,'fro')
% which is poorly estimated by sqrt(sum_i norm(d_i)^2)
sumnormd2 = 0;
resvec = zeros(maxit+1,1);     % Preallocate vector for norm of residuals
resvec(1) = normr;             % resvec(1,1) = norm(b-A*x0)
lsvec = zeros(maxit,1);        % Preallocate vector for least squares estimates
iter = maxit;                  % Assume lack of convergence until it happens

% loop over maxit iterations (unless convergence or failure)

for ii = 1 : maxit

    z = v;
    u = iterapp('mtimes',afun,atype,afcnstr,z,varargin{:},'notransp') - alpha * u;
    beta = norm(u);
    u = u / beta;
    norma = norm([norma alpha beta]);
    lsvec(ii) = normar / norma;
    thet = - s * alpha;
    rhot = c * alpha;
    rho = sqrt(rhot^2 + beta^2);
    c = rhot / rho;
    s = - beta / rho;
    phi = c * phibar;

    phibar = s * phibar;
    d = (z - thet * d) / rho;
    sumnormd2 = sumnormd2 + (norm(d))^2;
   
    x = x + phi * d;
    normr = abs(s) * normr;
    resvec(ii+1) = normr;
    vt = iterapp('mtimes',afun,atype,afcnstr,u,varargin{:},'transp');
    
    v = vt - beta * v;
    alpha = norm(v);
    v = v / alpha;
    normar = alpha * abs( s * phi);
    
end                            % for ii = 1 : maxit



relres = normr/n2b;


%{

if normar/(norma*normr) <= tol % check for convergence in min{|b-A*x|}
        flag = 0;
        iter = ii-1;
        resvec = resvec(1:iter+1);
        lsvec = lsvec(1:iter+1);
        break
    end
    
    if normr <= tolb           % check for convergence in A*x=b
        flag = 0;
        iter = ii-1;
        resvec = resvec(1:iter+1);
        lsvec = lsvec(1:iter+1);
        break
    end
%}


