function z = prox(op, lambda, x, H)

op.preConstant()

if nargin > 3 && ~isempty(H)
    warning('proxH');
    x = H.pinv(x);
end

for iii = 1 : length(op.varList)
    if ~op.varList{iii}.isConstant
        backup = op.varList{iii}.cache;
        op.varList{iii}.cache = x;
        break;
    end
end

%backup = op.varList{1}.cache;
%op.varList{1}.cache = x;

refidx = op.refList{end};
for ii = refidx
    if ~op.topoSort{ii}.isConstant
        c = op.topoSort{ii}.unitary;
        s = op.topoSort{ii}.shape;
        inputPos = ii;
        break
    end
end

len = length(op.topoSort);
cacheOutput = cell(1, len);

if c && (s >= 0 || ~op.proxOption.method) 

    cacheOutput = A(cacheOutput, len, op);
    tmp = op.prox_(lambda * op.mu * c, cacheOutput{refidx});
    if s
        tmp = tmp - cacheOutput{inputPos};
    end
    if c ~= 1
        tmp = tmp / c;
    end
    cacheOutput{inputPos} = tmp;
    [cacheOutput, varPos] = AT(cacheOutput, len, op);
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
            for iter = 1 : op.proxOption.maxIter
                cacheOutput = A(cacheOutput, len, op);
                tmp = op.prox_(lambda * op.mu * c, cacheOutput{refidx});
                if s <= 0
                    z = op.topoSort{inputPos}.pinv(tmp);
                else
                    z = x - op.topoSort{inputPos}.pinv(cacheOutput{inputPos} - tmp);
                end
                op.varList{1}.cache = z;
            end
        case 3 %SSD
        otherwise
            error(' ');
    end
        
end

op.varList{iii}.cache = backup;
%op.varList{1}.cache = backup;
end

function cacheOutput = A(cacheOutput, len, op)
for ii = 1 : len - 1
    if op.topoSort{ii}.isConstant
        cacheOutput{ii} = op.topoSort{ii}.cache;
    else
        cacheOutput{ii} = op.topoSort{ii}.apply_(cacheOutput{op.refList{ii}}, 0);
        cacheOutput(op.clearIdx{ii}) = {[]};
    end
end
end

function [cacheOutput, ii] = AT(cacheOutput, len, op)

for ii = len - 1 : -1 : 1
    idx = op.refList{ii};
    lenIdx = length(idx);
    if lenIdx
        [tmp{1:lenIdx}] = op.topoSort{ii}.gradOp_(cacheOutput{ii});
        for jj = 1 : lenIdx
            cacheOutput{idx(jj)} = tmp{jj};
        end
        cacheOutput{ii} = [];
    elseif ~op.topoSort{ii}.isConstant
        return
    end
end
end



