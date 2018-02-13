function c = cost( fbpd, state )

fbpd.costh = fbpd.h.eval(state.var);
fbpd.costf = fbpd.f.eval(state.var);
fbpd.costg = fbpd.g.eval(fbpd.A.apply(state.var));
c = fbpd.costf + fbpd.costg + fbpd.costh;

end

