function checkFun(pocs)


for ii = length(pocs.fList)
    if ~isa(pocs.fList{ii}, 'Indicator') || ~pocs.fList{ii}.isProx
        error(' ');
    end
end

end

