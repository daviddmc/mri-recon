function z = prox_(normh, lambda, x)

    omega = normh.omega;
    interval = abs(x) < lambda + omega;
    z = x - lambda * sign(x);
    z(interval) = x(interval) / (1 + lambda / omega);
    
end
    