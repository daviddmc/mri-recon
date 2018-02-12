function y = apply_(sm, x, ~)
    
if nargout > 0
    if sm.isAdjoint
        sizeMap = size(sm.map);
        nc = sizeMap(end);
        ndimMap = length(sizeMap);
        ndimX = ndims(x);
        sizeMap(ndimMap:ndimX) = 1;
        sizeMap(end) = nc;
        y = sum(bsxfun(@times, x, reshape(conj(sm.map), sizeMap)), ndimX);
    else
        sizeMap = size(sm.map);
        nc = sizeMap(end);
        ndimMap = length(sizeMap);
        ndimX = ndims(x);
        if ndimX >= ndimMap
            sizeMap(ndimMap:ndimX) = 1;
            sizeMap(end + 1) = nc;
        end
        y = bsxfun(@times, x, reshape(sm.map, sizeMap));
    end 
end