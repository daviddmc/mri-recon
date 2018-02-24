function verboseOutput(admm, state)

if isempty(admm.costf)
    c = cost( admm, state );
else
    c = admm.costf + admm.costg;
end

fprintf('f(x) = %f, g(x) = %f, total cost = %f | tau = %f, gamma = %f\n',...
    admm.costf, admm.costg, c, state.tau, state.gamma);

admm.costf = [];
admm.costg = [];

end

