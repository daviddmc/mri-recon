function c = cost( pg, state )

pg.costf = pg.f.eval(state.var);
pg.costg = pg.g.eval(state.var);
c = pg.costf + pg.costg;

end

