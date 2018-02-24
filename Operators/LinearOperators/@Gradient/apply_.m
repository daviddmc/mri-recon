function y = apply_(g, x, ~)


if nargout > 0
    if g.isAdjoint
        dim = g.dim;
        dimX = ndims(x);

        if length(dim) > 1
            dimX = dimX - 1;
        end

        weight = g.weight;
        if ~isempty(weight)
            shape = ones(1, ndims(x));
            shape(end) = length(weight);
            x = x .* reshape(conj(weight), shape);
        end

        for ii = 1 : length(dim)
            prefix = cell(1, dim(ii) - 1);
            suffix = cell(1, dimX - dim(ii));
            prefix(:) = {':'};
            suffix(:) = {':'};
            len = size(x, dim(ii));

            if isempty(prefix)
                x(len, suffix{:}, ii) = x(len-1, suffix{:}, ii);
                x(2:len-1, suffix{:}, ii) = ...
                x(1:len-2, suffix{:}, ii) - x(2:len-1, suffix{:}, ii);
                x(1, suffix{:}, ii) = -x(1, suffix{:}, ii);
            else
                x(prefix{:}, len, suffix{:}, ii) = x(prefix{:}, len-1, suffix{:}, ii);
                x(prefix{:}, 2:len-1, suffix{:}, ii) = ...
                    x(prefix{:}, 1:len-2, suffix{:}, ii) - x(prefix{:}, 2:len-1, suffix{:}, ii);
                x(prefix{:}, 1, suffix{:}, ii) = -x(prefix{:}, 1, suffix{:}, ii);
            end
        end

        y = sum(x, dimX + 1);
        
        g.sizeX = size(y);
    else
        
        dim = g.dim;
        dimX = ndims(x);
        weight = g.weight;

        y = zeros([size(x), length(dim)]);
        for ii = 1 : length(dim)
            prefix = cell(1, dim(ii) - 1);
            suffix = cell(1,dimX - dim(ii));
            prefix(:) = {':'};
            suffix(:) = {':'};
            len = size(x, dim(ii));

            if isempty(prefix)
                y(1:len-1, suffix{:}, ii) = ...
                    x(2:len, suffix{:}) - x(1:len-1, suffix{:});
            else
                y(prefix{:}, 1:len-1, suffix{:}, ii) = ...
                    x(prefix{:}, 2:len, suffix{:}) - x(prefix{:}, 1:len-1, suffix{:});
            end
        end

        if ~isempty(weight)
            shape = ones(1, ndims(y));
            shape(end) = length(weight);
            y = y .* reshape(weight, shape);
        end
    end
end
