function neglogLlhd = dataLlhd(priorScale, intNoise, target, response)
%DATALLHD Log likelihood of dataset in the format of target-response pairs
estimator = BayesianEstimator(priorScale, intNoise);
estimator.computeEstimator();

logLlhd = zeros(1, length(target));
parfor idx = 1:length(target)
    [domain, probDnst] = estimator.estimatePDF(target(idx));       
    dataProb = interp1(domain, probDnst, response(idx), 'linear', 'extrap');
    
    % Zero probability threshold
    if (dataProb < 1e-10)
        dataProb = 1e-10;
    end
    logLlhd(idx) = log(dataProb);
end

neglogLlhd = -sum(logLlhd);

end

