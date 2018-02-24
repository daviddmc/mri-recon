function checkFun(pocs)

for ii = length(pocs.inList)
    if ~pocs.inList{ii}.isProx
        error(' ');
    elseif length(pocs.inList{ii}.getVarList) ~= 1
        error(' ');
    end
end

end

