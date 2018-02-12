function z = prox_(tv, lambda, x)

ndimX = ndims(x);
ndimG = length(tv.dim);
r = zeros([size(x) ndimG]);
p0 = r;
t0 = 1;
maxIter = tv.proxOption.maxIter;
tol = tv.proxOption.tol;
GOP = tv.G;
if ~isempty(GOP.weight)
    weightMax = max(GOP.weight);
else
    weightMax = 1;
end
step = 1/(ndimG*4*lambda*abs(weightMax)); %use weightMax or weightMax^2??

cost0 = tv.eval(x) * lambda;

for iter = 1 : maxIter
        
    z = x + lambda*GOP.adjoint(r);
    
    cost = tv.eval_(z) * lambda + 0.5 * sum(abs(z(:) - x(:)).^2);
    costRel = (cost - cost0) / (cost0 + eps);
    if(abs(costRel) < tol && iter > 1)
        break;
    end
    cost0 = cost;
    
    g = GOP.apply(z);

    r = r - step * g;

    if strcmpi(tv.type,'isotropic')
        weights = max(1, sqrt(sum(abs(r).^2,ndimX + 1)));
    else
        weights = max(1, abs(r));
    end
    
    p = r ./ weights;
    t = (1+sqrt(4*t0.^2))/2;
    r = p + (t0-1)/t * (p - p0); 
    p0 = p;
    t0 = t;
end

end