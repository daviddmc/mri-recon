function checkFun(pocs)


for ii = length(pocs.fList)
    if ~pocs.fList{ii}.isProx
        error(' ');
    elseif length(pocs.fList{ii}.varList) ~= 1
        error(' ');
    end
end

end

