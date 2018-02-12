function [fun, grad] = funGrad(op, xList, t, pList)

persistent cacheOutputx cacheOutputp;

numInput = nargin;
if numInput == 1
    cacheOutputx = [];
    cacheOutputp = [];
    return
end

op.preConstant();

needGrad = nargout > 1;
onlyt = isempty(xList);
lv = length(op.varList);
len = length(op.topoSort);
%%%%%%%%%%%%%%%%%

if ~onlyt
    jj = 1;
    for ii = 1 : lv
        if ~op.varList{ii}.isConstant
            backup{ii} = op.varList{ii}.cache;
            op.varList{ii}.cache = xList{jj};
            jj = jj + 1;
        end
    end
end

if numInput == 4
  
    cacheOutputx = cell(1, len);

    for ii = op.idxLinear
        if op.topoSort{ii}.isConstant
            cacheOutputx{ii} = op.topoSort{ii}.cache;
        else
            cacheOutputx{ii} = op.topoSort{ii}.apply_(cacheOutputx{op.refList{ii}}, 0);
            cacheOutputx(op.clearIdx{ii}) = {[]};
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    jj = 1;
    for ii = 1 : lv
        if ~op.varList{ii}.isConstant
            op.varList{ii}.cache = pList{jj};
            jj = jj + 1;
        end
    end

    cacheOutputp = cell(1, len);

    for ii = op.idxLinear
        if op.topoSort{ii}.isConstant
            cacheOutputp{ii} = op.topoSort{ii}.cache;
        else
            cacheOutputp{ii} = op.topoSort{ii}.apply_(cacheOutputp{op.refList{ii}}, 0);
            cacheOutputp(op.clearIdx{ii}) = {[]};
        end
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%
cacheOutput = cell(1, len);

if numInput > 2

    for ii = op.idxLinear
        if ~isempty(cacheOutputx{ii})
            if op.topoSort{ii}.isConstant
                cacheOutput{ii} = cacheOutputx{ii};
            else
                cacheOutput{ii} = cacheOutputx{ii} + t * cacheOutputp{ii};
            end
        end
    end
    
    for ii = op.idxNonLinear
        cacheOutput{ii} = op.topoSort{ii}.apply_(cacheOutput{op.refList{ii}}, needGrad);
        cacheOutput(op.clearIdx{ii}) = {[]};
    end
    
else
    for ii = 1 : len
        if op.topoSort{ii}.isConstant
            cacheOutput{ii} = op.topoSort{ii}.cache;
        else
            cacheOutput{ii} = op.topoSort{ii}.apply_(cacheOutput{op.refList{ii}}, needGrad);
            cacheOutput(op.clearIdx{ii}) = {[]};
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fun = cacheOutput{end};

if needGrad

    cacheOutput{end} = 1;
    for ii = len : -1 : 1

        idx = op.refList{ii};
        lenIdx = length(idx);

        if lenIdx
            [tmp{1:lenIdx}] = op.topoSort{ii}.gradOp_(cacheOutput{ii});
            for jj = 1 : lenIdx
                if isempty(cacheOutput{idx(jj)})
                    cacheOutput{idx(jj)} = tmp{jj};
                else
                    cacheOutput{idx(jj)} = cacheOutput{idx(jj)} + tmp{jj};
                end
            end
            cacheOutput{ii} = [];
            op.topoSort{ii}.cache = [];
        else
            if ~op.topoSort{ii}.isConstant
                for jj = 1 : lv
                    if op.varList{jj}.name == op.topoSort{ii}.name
                        op.topoSort{ii}.cache = cacheOutput{ii};
                        break;
                    end
                end
            end
        end
    end
end

jj = 1;
for ii = 1 : lv
    if ~op.varList{ii}.isConstant
        if needGrad
            grad{jj} = op.varList{ii}.cache;
        end
        if ~onlyt
            op.varList{ii}.cache = backup{ii};
        end
        jj = jj + 1;
    end
end


end

