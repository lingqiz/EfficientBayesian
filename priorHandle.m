function prior = priorHandle(priorScale)
% Return the function handle to the default prior: 2 - scale * |sin(theta)|.
    stepSize = 0.01; stmSpc = 0 : stepSize : 2 * pi;
    priorUnm = 2 - priorScale * abs(sin(stmSpc));
    nrmConst = 1.0 / trapz(stmSpc, priorUnm);
    prior = @(support) (2 - priorScale * abs(sin(support))) * nrmConst;
end