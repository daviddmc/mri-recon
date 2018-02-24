function z = prox(op, lambda, x, H)

%op.preConstant()
[topoSort, refList, varList, clearIdx] = op.getTopoList();

if nargin > 3 && ~isempty(H)
    warning('proxH');
    x = H.pinv(x);
end

for iii = 1 : length(varList)
    if ~varList{iii}.isConstant
        backup = varList{iii}.cache;
        varList{iii}.cache = x;
        break;
    end
end

refidx = refList{end};
for ii = refidx
    if ~topoSort{ii}.isConstant
        c = topoSort{ii}.unitary;
        s = topoSort{ii}.shape;
        inputPos = ii;
        break
    end
end

len = length(topoSort);
cacheOutput = cell(1, len);

if c && (s >= 0 || ~op.proxOption.method) 

    cacheOutput = A(cacheOutput, len, topoSort, refList, clearIdx);
    tmp = op.prox_(lambda * op.mu * c, cacheOutput{refidx});
    if s
        tmp = tmp - cacheOutput{inputPos};
    end
    if c ~= 1
        tmp = tmp / c;
    end
    cacheOutput{inputPos} = tmp;
    [cacheOutput, varPos] = AT(cacheOutput, len, topoSort, refList);
    z = cacheOutput{varPos};
    if s
        z = z + x;
    end

else 

    switch op.proxOption.method
        case 1 %ADMM
            for iter = 1 : op.proxOption.maxIter
                error(' ');
            end
        case 2 %POCS
            for iter = 1 : op.proxOption.maxIterOuter
                cacheOutput = A(cacheOutput, len, topoSort, refList, clearIdx);
                %tmp = op.prox_(lambda * op.mu * c, cacheOutput{refidx});
                tmp = op.prox_(lambda * op.mu, cacheOutput{refidx});
                if s <= 0
                    z = topoSort{inputPos}.pinv(tmp);
                else
                    z = x - topoSort{inputPos}.pinv(cacheOutput{inputPos} - tmp);
                end
                op.varList{1}.cache = z;
            end
        case 3 %SSD
        otherwise
            error(' ');
    end
        
end

op.varList{iii}.cache = backup;
end

function cacheOutput = A(cacheOutput, len, topoSort, refList, clearIdx)
for ii = 1 : len - 1
    if topoSort{ii}.isConstant
        cacheOutput{ii} = topoSort{ii}.cache;
    else
        cacheOutput{ii} = topoSort{ii}.apply_(cacheOutput{refList{ii}}, 0);
        cacheOutput(clearIdx{ii}) = {[]};
    end
end
end

function [cacheOutput, ii] = AT(cacheOutput, len, topoSort, refList)

for ii = len - 1 : -1 : 1
    idx = refList{ii};
    lenIdx = length(idx);
    if lenIdx
        [tmp{1:lenIdx}] = topoSort{ii}.gradOp_(cacheOutput{ii});
        for jj = 1 : lenIdx
            cacheOutput{idx(jj)} = tmp{jj};
        end
        cacheOutput{ii} = [];
    elseif ~topoSort{ii}.isConstant
        return
    end
end
end



