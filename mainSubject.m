%% TD Individual Level
dataDir = './woFB/TD/*.mat';
nBins = 6; showPlot = false;
[scale_woFB, noise_woFB] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB1/TD/*.mat';
[scale_wFB1, noise_wFB1] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB2/TD/*.mat';
[scale_wFB2, noise_wFB2] = subjectExtractExtend(dataDir, nBins, showPlot);

%% Plot
figure(1); subplot(2, 2, 1);
boxplot([scale_woFB', scale_wFB1', scale_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Prior Weight $$ \omega $$ TD Group', 'interpreter', 'latex'); ylim([0, 1.01]);

subplot(2, 2, 3);
boxplot([noise_woFB', noise_wFB1', noise_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Total $$ \sqrt{J(\theta)} $$ TD Group', 'interpreter', 'latex'); ylim([4, 30]);

xLoc = [0.8, 2, 3.2];
figure(2);  subplot(1, 2, 1); 
colors = get(gca,'colororder');
plotScatter(xLoc, [scale_woFB; scale_wFB1; scale_wFB2], colors(1, :), -0.2);
title('Prior Weight $$ \omega $$', 'interpreter', 'latex');

subplot(1, 2, 2); 
plotScatter(xLoc, [noise_woFB; noise_wFB1; noise_wFB2], colors(1, :), -0.2);
title('Total $$ \sqrt{J(\theta)} $$', 'interpreter', 'latex'); ylim([4, 30]);

figure(3); subplot(2, 2, 1);
plotLines(xLoc, [scale_woFB; scale_wFB1; scale_wFB2], colors(1, :));
title('Prior Weight $$ \omega $$', 'interpreter', 'latex');

subplot(2, 2, 3); 
plotLines(xLoc, [noise_woFB; noise_wFB1; noise_wFB2], colors(1, :));
title('Total $$ \sqrt{J(\theta)} $$', 'interpreter', 'latex'); ylim([4, 30]);

%% ASD Individual Level
dataDir = './woFB/ASD/*.mat';
nBins = 6; showPlot = false;
[scale_woFB, noise_woFB] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB1/ASD/*.mat';
[scale_wFB1, noise_wFB1] = subjectExtractExtend(dataDir, nBins, showPlot);

dataDir = './wFB2/ASD/*.mat';
[scale_wFB2, noise_wFB2] = subjectExtractExtend(dataDir, nBins, showPlot);

%% Plot
figure(1); subplot(2, 2, 2);
boxplot([scale_woFB', scale_wFB1', scale_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Prior Weight $$ \omega $$ ASD Group', 'interpreter', 'latex'); ylim([0, 1.01]);

subplot(2, 2, 4);
boxplot([noise_woFB', noise_wFB1', noise_wFB2'], 'Labels',{'woFB', 'wFB1', 'wFB2'});
title('Total $$ \sqrt{J(\theta)} $$ ASD Group', 'interpreter', 'latex'); ylim([4, 30]);

suptitle('Individual Analysis');

figure(2);  subplot(1, 2, 1); 
plotScatter(xLoc + 0.1, [scale_woFB; scale_wFB1; scale_wFB2], colors(2, :), +0.2);

subplot(1, 2, 2); 
plotScatter(xLoc + 0.1, [noise_woFB; noise_wFB1; noise_wFB2], colors(2, :), +0.2);

suptitle('Individual Analysis');

figure(3); subplot(2, 2, 2);
plotLines(xLoc, [scale_woFB; scale_wFB1; scale_wFB2], colors(2, :));
title('Prior Weight $$ \omega $$', 'interpreter', 'latex');

subplot(2, 2, 4); 
plotLines(xLoc, [noise_woFB; noise_wFB1; noise_wFB2], colors(2, :));
title('Total $$ \sqrt{J(\theta)} $$', 'interpreter', 'latex'); ylim([4, 30]);

suptitle('Individual Analysis');

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
        
    [thisScale, thisNoise] = fitExtract(target', response', nBins, showPlot);
    scale = [scale, thisScale];
    noise = [noise, thisNoise];
end

end

function [scale, noise] = extractPriorExtend(target, response, nBins, showPlot)

% convert to [0, 2 pi] range
target   = target / 180 * (2 * pi);
response = response / 180 * (2 * pi);

% mirroring the data
target_lh   = target(target <= pi) + pi;
response_lh = response(target <= pi) + pi;

target_hh   = target(target > pi) - pi;
response_hh = response(target > pi) - pi;

target   = wrapTo2Pi([target; target_lh; target_hh]);
response = wrapTo2Pi([response; response_lh; response_hh]);

% analysis
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
scale = fmincon(loss, 1, [], [], [], [], 0, 1);

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

function plotScatter(xLoc, allPara, dotColor, offSet)
for idx = 1:length(xLoc)
    para = allPara(idx, :);
    scatter(xLoc(idx) * ones(size(para)), para, ...
        'MarkerEdgeColor', dotColor, 'MarkerFaceColor', dotColor); hold on;        
end
errorbar(xLoc + offSet, mean(allPara, 2), std(allPara, 0, 2) / sqrt(size(allPara, 2)), 'o', 'Color', dotColor);

xlim([0.5, 3.6]); xticks([0.8, 2, 3.2]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
end

function plotLines(xLoc, allPara, lineColor)
for idx = 1:size(allPara, 2)
    plot(xLoc, allPara(:, idx), '-o', 'LineWidth', 1, 'Color', lineColor); hold on;
end

xlim([0.5, 3.6]); xticks([0.8, 2, 3.2]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
end
