function varargout = gradOp(op, y, varargin)

op.preConstant();

l = length(varargin);
lv = length(op.varList);

jj = 1;
ii = 1;
backup{lv} = [];
while ii <= l
    if ~op.varList{jj}.isConstant
        backup{jj} = op.varList{jj}.cache;
        op.varList{jj}.cache = varargin{ii};
        ii = ii + 1;
    end
    jj = jj + 1;
end

%for ii = l+1 : lv
%    backup{ii} = [];
%end

lenFull = length(op.topoSort);
len = lenFull;%op.lenGrad;
while 1
    if len && op.topoSort{len}.isLinear_
        len = len - 1;
    else
        break
    end
end


cacheOutput = cell(1, len);

for ii = 1 : len - 1
    if op.topoSort{ii}.isConstant
        cacheOutput{ii} = op.topoSort{ii}.cache;
    else
        cacheOutput{ii} = op.topoSort{ii}.apply_(cacheOutput{op.refList{ii}}, 1);
        cacheOutput(op.clearIdx{ii}) = {[]};
    end
end

if len
    op.topoSort{len}.apply_(cacheOutput{op.refList{len}}, 1);
end

cacheOutput = cell(1, lenFull);
cacheOutput{lenFull} = y;

for ii = lenFull : -1 : 1
   
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
                    %varargout{jj} = cacheOutput{ii};
                    %op.topoSort{ii}.cache = backup{jj};
                    break;
                end
            end
        end
    end
end

jj = 1;
for ii = 1 : lv
    if ~op.varList{ii}.isConstant
        varargout{jj} = op.varList{ii}.cache;
        op.varList{ii}.cache = backup{ii};
        jj = jj + 1;
    end
end


end

