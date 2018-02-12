 function p = powerProx(x, gamma, q)
 
% compute the prox
if q == 1
    
    p = softThreshold(x, lambda);
    
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
                 
else
    
    % prepare the Newton's method
    fun = @(t) q * gamma .* t.^(q-1) + t - abs(x);
    der = @(t) q*(q-1) * gamma .* t.^(q-2) + 1;
    
    % initialize the solution
    p_init = abs(x);
    
    % use the Newton's method
    p = newton(fun, der, p_init);
    
    % compute the prox   
    p = sign(x) .* p;
                    
end

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