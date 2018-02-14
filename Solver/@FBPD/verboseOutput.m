function verboseOutput(fbpd, state)

if isempty(fbpd.costf)
    costf = fbpd.f.eval(state.var);
    costg = fbpd.g.eval(fbpd.A.apply(state.var));
    costh = fbpd.h.eval(state.var);
else
    costf = fbpd.costf;
    costg = fbpd.costg;
    costh = fbpd.costh;
end

fbpd.costf = [];
fbpd.costg = [];
fbpd.costh = [];

fprintf('f(x) = %f, g(x) = %f, h(x) = %f, total cost = %f\n', costf, costg, costh, costf + costg + costh);

end

