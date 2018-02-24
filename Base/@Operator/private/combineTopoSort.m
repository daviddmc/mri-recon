function [topoSort, refList, pos] = combineTopoSort( topoSort1, refList1,...
    topoSort2, refList2)

topoSort = topoSort1;
refList = refList1;
len1 = length(topoSort1);
len2 = length(topoSort2);
ref2 = zeros(1, len2);
k = len1;
for ii = 1 : len2
    flag = 1;
    for jj = 1 : len1
        if topoSort1{jj}.id == topoSort2{ii}.id
            flag = 0;
            ref2(ii) = jj;
            break;
        end
    end
    if flag
        topoSort{end+1} = topoSort2{ii};
        k = k + 1;
        ref2(ii) = k;
        refList{end+1} = ref2(refList2{ii});
    end
end

for ii = length(topoSort):-1:1
    if topoSort{ii}.id == topoSort2{end}.id
        pos = ii;
        break;
    end
end


end

