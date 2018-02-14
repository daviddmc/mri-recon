function verboseOutput(admm, state)

if isempty(admm.costf)
    c = cost( admm, state );
else
    c = admm.costf + admm.costg;
end

admm.costf = [];
admm.costg = [];

fprintf('f(x) = %f, g(x) = %f, total cost = %f | tau = %f, gamma = %f\n',...
    admm.costf, admm.costf, c, state.tau, state.gamma);

end

