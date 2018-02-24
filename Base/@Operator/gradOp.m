function varargout = gradOp(op, y, varargin)

[topoSort, refList, varList, clearIdx] = op.getTopoList();

l = length(varargin);
lv = length(varList);

jj = 1;
ii = 1;
backup{lv} = [];
while ii <= l
    if ~varList{jj}.isConstant
        backup{jj} = varList{jj}.cache;
        varList{jj}.cache = varargin{ii};
        ii = ii + 1;
    end
    jj = jj + 1;
end

len = length(topoSort);
cacheOutput = cell(1, len);

if ~op.isLinear
    
    if ~isa(op, 'Functional')
        error(' ');
    end
    
    for ii = 1 : len - 1
        if topoSort{ii}.isConstant
            cacheOutput{ii} = topoSort{ii}.cache;
        else
            cacheOutput{ii} = topoSort{ii}.apply_(cacheOutput{refList{ii}}, 1);
            cacheOutput(clearIdx{ii}) = {[]};
        end
    end
    topoSort{len}.apply_(cacheOutput{refList{len}}, 1);
    cacheOutput(clearIdx{len}) = {[]};
end

cacheOutput{len} = y;

for ii = len : -1 : 1
   
    idx = refList{ii};
    lenIdx = length(idx);
    
    if lenIdx
        [tmp{1:lenIdx}] = topoSort{ii}.gradOp_(cacheOutput{ii});
        for jj = 1 : lenIdx
            if isempty(cacheOutput{idx(jj)})
                cacheOutput{idx(jj)} = tmp{jj};
            else
                cacheOutput{idx(jj)} = cacheOutput{idx(jj)} + tmp{jj};
            end
        end
        cacheOutput{ii} = [];
        topoSort{ii}.cache = [];
    else
        if ~topoSort{ii}.isConstant
            for jj = 1 : lv
                if varList{jj} == topoSort{ii}
                    topoSort{ii}.cache = cacheOutput{ii};
                    break;
                end
            end
        end
    end
end

jj = 1;
for ii = 1 : lv
    if ~varList{ii}.isConstant
        varargout{jj} = varList{ii}.cache;
        varList{ii}.cache = backup{ii};
        jj = jj + 1;
    end
end

end

