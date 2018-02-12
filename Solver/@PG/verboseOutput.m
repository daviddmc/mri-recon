function verboseOutput(pg, state)

if isempty(pg.costf)
    costf = pg.f.eval(state.var);
    costg = pg.g.eval(state.var);
else
    costf = pg.costf;
    costg = pg.costg;
    pg.costf = [];
    pg.costg = [];
end

fprintf('f(x) = %f, g(x) = %f, total cost = %f\n', costf, costg, costf + costg);

end

