function state = update( pg, state )

x = state.var;

for ii = 1 : length(pg.fList)
    x = pg.fList{ii}.prox([], x);
end

state.var = x;

end

