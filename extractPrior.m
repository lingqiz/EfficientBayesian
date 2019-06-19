function [scale, noise] = extractPrior(target, response, nBins, showPlot)

% convert to [0, 2 pi] range
target = target / 180 * (2 * pi);
response = response / 180 * (2 * pi);

average = zeros(1, nBins);
spread  = zeros(1, nBins);
center  = zeros(1, nBins);
[Y, E] = discretize(target, nBins);

for idx = 1:nBins
    binData = response(Y == idx);
    center(idx) = (E(idx) + E(idx + 1)) / 2;
    
    meanRes = circ_mean(binData);
    average(idx) = wrapToPi(meanRes - center(idx));
    spread(idx)  = circ_kappa(binData);
end

% calculate fisher information
spread = 1 ./ spread;
fisher = (1 + gradient(average, center)) ./ sqrt(abs(spread));
prior = fisher ./ trapz(center, fisher);

noise = trapz(center, fisher);
loss  = @(priorScale) priorLoss(priorScale, center, prior);
scale = fmincon(loss, 1, [], [], [], [], 0, 2);

if showPlot    
    figure();
    subplot(3, 1, 1);
    plot(center, average, 'k', 'LineWidth', 2);
    grid on; xlim([0, 2 * pi]);
    title('Bias');
    
    subplot(3, 1, 2);
    plot(center, sqrt(abs(spread)), 'k', 'LineWidth', 2);
    grid on; xlim([0, 2 * pi]);
    title('SD');
    
    subplot(3, 1, 3);        
    plot(center, prior, 'k', 'LineWidth', 2);
    grid on; hold on; xlim([0, 2 * pi]);
        
    priorDist = priorHandle(scale);
    domain = 0 : 0.025 : 2 * pi;
    plot(domain, priorDist(domain), '--k', 'LineWidth', 2);
    title('Sqrt Fisher');        
end    

    function loss = priorLoss(priorScale, center, value)
        priorFunc = priorHandle(priorScale);
        loss = norm(priorFunc(center) - value);
    end

end

