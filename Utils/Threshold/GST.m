function z = GST(x, gamma, p, nIter)
%GST   Generalized Soft Thresholding
%   Z = GST(X,GAMMA,P) solves the following problem
%
%      argmin_Z   1/2*||Z-X||^2 + GAMMA*||X||_P^P)/P
%
%   where GAMMA and P are positive numbers.
%   
%   Z = GST(X,GAMMA,P,NITER) specifies the number of iterations. GST
%   provides a closed form solution when P = 1 or 2, otherwise it uses
%   iterative method to get an approximate solution (fixed-point iteration 
%   for 0 < P < 1 and newton method for P > 1, P ~= 2). If NITER is not
%   provided, GST uses the default, 1.
%
%   See also softThreshold

%   Reference:
%   [1]Combettes, P. L., & Pesquet, J. C. (2011). Proximal splitting 
%   methods in signal processing. Heinz H Bauschke, 49, p¨¢gs. 185-212.
%
%   Copyright 2018 Junshen Xu

if p == 1
    
    z = softThreshold(x, lambda);
    
elseif p == 2
    
    z = x / (gamma+1);
    
else
    
    if nargin < 4
        nIter = 1;
    end
    absx = abs(x);
    z = absx;
    
    if p < 1
        for iter = 1 : nIter
            z = absx - gamma * z.^(p-1);
            z(z < 0) = 0;
        end            
    else
        for iter = 1 : nIter
            f = gamma * z.^(p-1) + z - absx;
            df = (p-1) * gamma * z.^(p-2) + 1;
            z = z - f ./ df;
            p = min(max(1e-10,p),1e10);
        end
    end
    z = sign(x) .* z;                
end
%{
function p = newton(fun, der, p, low, high)

% default parameters
TOL = 1e-7;
MAX = 100;
if nargin < 4, low  = eps; end
if nargin < 5, high = Inf; end
%-----%

for it = 1:MAX
    
    p_old = p;
    
    p = p - fun(p) ./ der(p);  % newton step
    p = min(max(low,p),high);  % range constraint
    
    err = abs(p-p_old) ./ abs(p_old);
    
    if all(err(:) <= TOL)
        break;
    end
    
end

%}
%{
elseif q == 4/3
    
    xi = sqrt(x.^2 + 256 * gamma.^3 / 729);
    gamma = 4 / (3*nthroot(2,3)) * gamma;
    p = x + gamma * (nthroot(xi-x,3) - nthroot(xi+x,3)) ;
	
elseif q == 3/2

    p = x + 9/8 * gamma^2 * sign(x) .* ( 1 - sqrt(1 + (16/9/gamma^2) * abs(x)) );
					
elseif q == 2
    
    p = x / (2*gamma+1);
    
elseif q == 3
    
	p = sign(x) .* ( sqrt(1 + 12*gamma*abs(x)) - 1 ) / (6*gamma);
                    
elseif q == 4

    xi = sqrt( x.^2 + 1/(27*gamma) );
    p = nthroot((xi+x)/(8*gamma), 3) - nthroot((xi-x)/(8*gamma), 3);


% prepare the Newton's method
        fun = @(t) p * gamma .* t.^(p-1) + t - abs(x);
        der = @(t) p*(p-1) * gamma .* t.^(p-2) + 1;

        % initialize the solution
        p_init = abs(x);

        % use the Newton's method
        z = newton(fun, der, p_init);

        % compute the prox   
        z = sign(x) .* z;
%}