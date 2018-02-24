function [fun, grad] = funGrad(op, xList, t, pList)

persistent cacheOutputx cacheOutputp;

numInput = nargin;
if numInput == 1
    cacheOutputx = [];
    cacheOutputp = [];
    return
end

[topoSort, refList, varList, clearIdx] = op.getTopoList();

needGrad = nargout > 1;
onlyt = isempty(xList);
lv = length(varList);
len = length(topoSort);
%%%%%%%%%%%%%%%%%

if ~onlyt
    jj = 1;
    for ii = 1 : lv
        if ~varList{ii}.isConstant
            backup{ii} = varList{ii}.cache;
            varList{ii}.cache = xList{jj};
            jj = jj + 1;
        end
    end
end

if numInput == 4
  
    cacheOutputx = cell(1, len);

    for ii = op.idxLinear
        if topoSort{ii}.isConstant
            cacheOutputx{ii} = topoSort{ii}.cache;
        else
            cacheOutputx{ii} = topoSort{ii}.apply_(cacheOutputx{refList{ii}}, 0);
            cacheOutputx(clearIdx{ii}) = {[]};
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    jj = 1;
    for ii = 1 : lv
        if ~varList{ii}.isConstant
            varList{ii}.cache = pList{jj};
            jj = jj + 1;
        end
    end

    cacheOutputp = cell(1, len);

    for ii = op.idxLinear
        if topoSort{ii}.isConstant
            cacheOutputp{ii} = topoSort{ii}.cache;
        else
            cacheOutputp{ii} = topoSort{ii}.apply_(cacheOutputp{refList{ii}}, 0);
            cacheOutputp(clearIdx{ii}) = {[]};
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%
cacheOutput = cell(1, len);

if numInput > 2

    for ii = op.idxLinear
        if ~isempty(cacheOutputx{ii})
            if topoSort{ii}.isConstant
                cacheOutput{ii} = cacheOutputx{ii};
            else
                cacheOutput{ii} = cacheOutputx{ii} + t * cacheOutputp{ii};
            end
        end
    end
    
    for ii = op.idxNonLinear
        cacheOutput{ii} = topoSort{ii}.apply_(cacheOutput{refList{ii}}, needGrad);
        cacheOutput(clearIdx{ii}) = {[]};
    end
    
else
    for ii = 1 : len
        if topoSort{ii}.isConstant
            cacheOutput{ii} = topoSort{ii}.cache;
        else
            cacheOutput{ii} = topoSort{ii}.apply_(cacheOutput{refList{ii}}, needGrad);
            cacheOutput(clearIdx{ii}) = {[]};
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun = cacheOutput{end};

if needGrad

    cacheOutput{end} = 1;
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
end

jj = 1;
for ii = 1 : lv
    if ~varList{ii}.isConstant
        if needGrad
            grad{jj} = varList{ii}.cache;
        end
        if ~onlyt
            varList{ii}.cache = backup{ii};
        end
        jj = jj + 1;
    end
end


end

