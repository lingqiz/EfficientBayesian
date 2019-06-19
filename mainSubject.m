%% TD Individual Level
dataDir = './woFB/TD/*.mat';
nBins = 10; showPlot = false;
[scale_woFB, noise_woFB] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB1/TD/*.mat';
nBins = 10; showPlot = false;
[scale_wFB1, noise_wFB1] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB2/TD/*.mat';
nBins = 10; showPlot = false;
[scale_wFB2, noise_wFB2] = subjectExtractExtend(dataDir, nBins, showPlot);

%% Plot
figure(); subplot(2, 2, 1);
boxplot([scale_woFB', scale_wFB1', scale_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Prior, TD Group'); ylim([0, 2]);

subplot(2, 2, 3);
boxplot([noise_woFB', noise_wFB1', noise_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Noise, TD Group'); ylim([4, 30]);

%% ASD Individual Level
dataDir = './woFB/ASD/*.mat';
nBins = 10; showPlot = false;
[scale_woFB, noise_woFB] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB1/ASD/*.mat';
nBins = 10; showPlot = false;
[scale_wFB1, noise_wFB1] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB2/ASD/*.mat';
nBins = 10; showPlot = false;
[scale_wFB2, noise_wFB2] = subjectExtractExtend(dataDir, nBins, showPlot);

%% Plot
subplot(2, 2, 2);
boxplot([scale_woFB', scale_wFB1', scale_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Prior, ASD Group'); ylim([0, 2]);

subplot(2, 2, 4);
boxplot([noise_woFB', noise_wFB1', noise_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Noise, ASD Group'); ylim([4, 30]);

%% Helper functions
function [scale, noise] = subjectExtractExtend(dataDir, nBins, showPlot)

    function input = wrapOrientation(input)
        assert(sum(input > 360) == 0 && sum(input < 0) == 0);
        input(input > 180) = input(input > 180) - 180;
    end

files = dir(dataDir);

scale = [];
noise = [];
for file = files'
    data = load(fullfile(file.folder, file.name));
    target   = data.all_data(1, :);
    response = data.all_data(2, :);
    
    data_idx = target > 0;
    target = wrapOrientation(target(data_idx));
    response = wrapOrientation(response(data_idx));
    
    [thisScale, thisNoise] = extractPriorExtend(target', response', nBins, showPlot);
    scale = [scale, thisScale];
    noise = [noise, thisNoise];
end

end

function [scale, noise] = extractPriorExtend(target, response, nBins, showPlot)

% convert to [0, 2 pi] range
target = target / 180 * (2 * pi);
response = response / 180 * (2 * pi);

delta = (2*pi / nBins) / 2;
range = 0: 0.05: 2*pi;

average = zeros(1, length(range));
spread  = zeros(1, length(range));

for idx = 1:length(range)
    binLB = range(idx) - delta;
    binUB = range(idx) + delta;
    
    if binLB < 0
        binLB = wrapTo2Pi(binLB);
        binData = response(target >= binLB | target <= binUB);
    elseif binUB > 2 * pi
        binUB = wrapTo2Pi(binUB);
        binData = response(target >= binLB | target <= binUB);
    else
        binData = response(target >= binLB & target <= binUB);
    end
        
    meanRes = circ_mean(binData);
    average(idx) = wrapToPi(meanRes - range(idx));
    spread(idx)  = circ_kappa(binData);
end

% calculate fisher information
spread = 1 ./ spread;
fisher = (1 + gradient(average, range)) ./ sqrt(abs(spread));
prior = fisher ./ trapz(range, fisher);

noise = trapz(range, fisher);
loss  = @(priorScale) priorLoss(priorScale, range, prior);
scale = fmincon(loss, 1, [], [], [], [], 0, 2);

if showPlot    
    figure();
    subplot(3, 1, 1);
    plot(range, average, 'k', 'LineWidth', 2);
    grid on; xlim([0, 2 * pi]);
    title('Bias');
    
    subplot(3, 1, 2);
    plot(range, sqrt(abs(spread)), 'k', 'LineWidth', 2);
    grid on; xlim([0, 2 * pi]);
    title('SD');
    
    subplot(3, 1, 3);        
    plot(range, prior, 'k', 'LineWidth', 2);
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

