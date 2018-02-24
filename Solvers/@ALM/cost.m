function c = cost( alm, state )

c = 0;
for ii = 1 : length(alm.fList)
    alm.costList(ii) = alm.fList{ii}.eval(state.var{alm.fidxList{ii}});
    c = c + alm.costList(ii);
end

end

