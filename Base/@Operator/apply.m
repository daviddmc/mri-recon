function y = apply(op, varargin)

%op.preConstant();
[topoSort, refList, varList, clearIdx] = op.getTopoList();

lv = length(varList);

jj = 1;
for ii = 1 : lv
    if ~varList{ii}.isConstant
        backup{ii} = varList{ii}.cache;
        varList{ii}.cache = varargin{jj};
        jj = jj + 1;
    end
end

len = length(topoSort);
cacheOutput = cell(1, len);

for ii = 1 : len
    if topoSort{ii}.isConstant
        cacheOutput{ii} = topoSort{ii}.cache;
    else
        cacheOutput{ii} = topoSort{ii}.apply_(cacheOutput{refList{ii}}, 0);
        cacheOutput(clearIdx{ii}) = {[]};
    end
end

y = cacheOutput{len};

for ii = 1 : lv
    if ~varList{ii}.isConstant
        varList{ii}.cache = backup{ii};
    end
end