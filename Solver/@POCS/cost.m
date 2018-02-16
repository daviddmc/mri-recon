function c = cost( pocs, state )

c = 0;
for ii = 1 : length(pocs.fList)
    pocs.costList(ii) = pocs.fList{ii}.eval(state.var);
    c = c + pocs.costList(ii);
end


end

