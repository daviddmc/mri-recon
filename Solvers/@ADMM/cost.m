function c = cost( admm, state )

if state.useB
    admm.costf = admm.f.eval(admm.B.apply(state.var));
else
    admm.costf = admm.f.eval(state.var);
end
admm.costg = admm.g.eval(state.var);
c = admm.costf + admm.costg;

end

