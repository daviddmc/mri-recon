function y = pinv(op, x)

op.preConstant();

%cacheOutput = cell(1, len);

%if len
%    op.topoSort{len}.apply_(cacheOutput{op.refList{len}}, 1);
%end

%cacheOutput = cell(1, len);
%cacheOutput{len} = x;
y = x;
for ii = length(op.topoSort) : -1 : 1
    
    if ~op.topoSort{ii}.isConstant
        y = op.topoSort{ii}.pinv_(y);
    end
    %{
    idx = op.refList{ii};
    lenIdx = length(idx);
    [tmp{1:lenIdx}] = op.topoSort{ii}.pinv_(cacheOutput{ii});
    
    if lenIdx
        for jj = 1 : lenIdx
            cacheOutput{idx(jj)} = tmp{jj};
        end
        cacheOutput{ii} = [];
    elseif ~op.topoSort{ii}.isConstant
        y = cacheOutput{ii};
        break;
    end
    %}
end

end

