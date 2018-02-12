function y = JacOp(op, varargin)

len = length(varargin);
dx = varargin(1:len/2);
x = varargin(len/2+1:1);

for ii = 1 : length(op.varList)
    backup{ii} = op.varList{ii}.cache;
    op.varList{ii}.cache = x{ii};
end

len = op.lenGrad;
lenFull = length(op.topoSort);
cacheOutput = cell(1, len);

for ii = 1 : len - 1
    if op.topoSort{ii}.isConstant
        cacheOutput{ii} = op.topoSort{ii}.cache;
    else
        cacheOutput{ii} = op.topoSort{ii}.apply_(cacheOutput{op.refList{ii}}, 2);
        cacheOutput(op.clearIdx{ii}) = {[]};
    end
end

if len
    op.topoSort{len}.apply_(cacheOutput{op.refList{len}}, 2);
end

cacheOutput = cell(1, lenFull);

for ii = 1 : length(op.varList)
    op.varList{ii}.cache = dx{ii};
end

for ii = 1 : lenFull
    cacheOutput{ii} = op.topoSort{ii}.JacOp_(cacheOutput{op.refList{ii}});
    cacheOutput(op.clearIdx{ii}) = {[]};
end

y = cacheOutput{lenFull};

for ii = 1 : length(op.varList)
    op.varList{ii}.cache = backup{ii};
end

end

