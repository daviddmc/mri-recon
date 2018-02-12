function y = apply(op, varargin)

op.preConstant();

jj = 1;
for ii = 1 : length(op.varList)
    if ~op.varList{ii}.isConstant
        backup{ii} = op.varList{ii}.cache;
        op.varList{ii}.cache = varargin{jj};
        jj = jj + 1;
    end
end

len = length(op.topoSort);
cacheOutput = cell(1, len);

for ii = 1 : len
    if op.topoSort{ii}.isConstant
        cacheOutput{ii} = op.topoSort{ii}.cache;
    else
        cacheOutput{ii} = op.topoSort{ii}.apply_(cacheOutput{op.refList{ii}}, 0);
        cacheOutput(op.clearIdx{ii}) = {[]};
    end
end

y = cacheOutput{len};

for ii = 1 : length(op.varList)
    if ~op.varList{ii}.isConstant
        op.varList{ii}.cache = backup{ii};
    end
end