%% TD Individual Level
dataDir = './woFB/TD/*.mat';
nBins = 10; showPlot = false;
[scale_woFB, noise_woFB] = subjectExtractExtend(dataDir, nBins, showPlot, zeros(1, 3));

dataDir = './wFB1/TD/*.mat';
[scale_wFB1, noise_wFB1] = subjectExtractExtend(dataDir, nBins, showPlot, zeros(1, 3));

dataDir = './wFB2/TD/*.mat';
[scale_wFB2, noise_wFB2] = subjectExtractExtend(dataDir, nBins, showPlot, zeros(1, 3));

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
nBins = 10; showPlot = false;
[scale_woFB, noise_woFB] = subjectExtractExtend(dataDir, nBins, showPlot, zeros(1, 3));

dataDir = './wFB1/ASD/*.mat';
[scale_wFB1, noise_wFB1] = subjectExtractExtend(dataDir, nBins, showPlot, zeros(1, 3));

dataDir = './wFB2/ASD/*.mat';
[scale_wFB2, noise_wFB2] = subjectExtractExtend(dataDir, nBins, showPlot, zeros(1, 3));

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

%% Plot individual data - TD
plotSubject('./woFB/TD/*.mat', './wFB1/TD/*.mat', './wFB2/TD/*.mat', 'TD-', './SubjectPlot/TD')

%% Plot individual data - ASD
plotSubject('./woFB/ASD/*.mat', './wFB1/ASD/*.mat', './wFB2/ASD/*.mat', 'ASD-', './SubjectPlot/ASD')

%% Prepare data for correlation analysis
[prior_td, noise_td]   = collectFit('./woFB/TD/*.mat', './wFB1/TD/*.mat', './wFB2/TD/*.mat', 25);
[prior_asd, noise_asd] = collectFit('./woFB/ASD/*.mat', './wFB1/ASD/*.mat', './wFB2/ASD/*.mat', 17);

%% Correlation Analysis, prior at end of training
sessionID = 4;

figure(); subplot(1, 2, 1);
scatter(prior_td(:, 5), prior_td(:, sessionID), 20, 'k');
hold on; grid on;
scatter(prior_asd(:, 5), prior_asd(:, sessionID), 20, 'r');
xlabel('AQ score'); ylabel('Prior, end of learning');

lm = fitlm([prior_td(:, 5); prior_asd(:, 5)], [prior_td(:, sessionID); prior_asd(:, sessionID)], ...
    'linear', 'RobustOpts', 'on');
lm.Coefficients

line = plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);
legend(line, 'p = 0.0026');

subplot(1, 2, 2);
scatter(prior_td(:, 6), prior_td(:, sessionID), 20, 'k');
hold on; grid on;
scatter(prior_asd(:, 6), prior_asd(:, sessionID), 20, 'r');
xlabel('SCQ score'); ylabel('Prior, end of learning');

lm = fitlm([prior_td(:, 6); prior_asd(:, 6)], [prior_td(:, sessionID); prior_asd(:, sessionID)], ...
    'linear', 'RobustOpts', 'on');
lm.Coefficients

line = plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);
legend(line, 'p = 0.052');

suptitle('Correlation, Prior end of learning');

%% Correlation Analysis, Change in Prior
figure(); subplot(1, 2, 1);
scatter(prior_td(:, 5), prior_td(:, 2) - prior_td(:, 3), 20, 'k');
hold on; grid on;
scatter(prior_asd(:, 5), prior_asd(:, 2) - prior_asd(:, 3), 20, 'r');
xlabel('AQ score'); ylabel('Change in Prior');

lm = fitlm([prior_td(:, 5); prior_asd(:, 5)], [prior_td(:, 2) - prior_td(:, 3); prior_asd(:, 2) - prior_asd(:, 3)], ...
    'linear', 'RobustOpts', 'on');
lm.Coefficients

plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);

subplot(1, 2, 2);
scatter(prior_td(:, 6), prior_td(:, 2) - prior_td(:, 3), 20, 'k');
hold on; grid on;
scatter(prior_asd(:, 6), prior_asd(:, 2) - prior_asd(:, 3), 20, 'r');
xlabel('SCQ score'); ylabel('Change in Prior');

lm = fitlm([prior_td(:, 6); prior_asd(:, 6)], [prior_td(:, 2) - prior_td(:, 3); prior_asd(:, 2) - prior_asd(:, 3)], ...
    'linear', 'RobustOpts', 'on');
lm.Coefficients

plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);

%% Correlation Analysis, FI before learning
colID = 2;
figure(); subplot(1, 2, 1);
scatter(noise_td(:, 5), noise_td(:, colID), 20, 'k');
hold on; grid on;
scatter(noise_asd(:, 5), noise_asd(:, colID), 20, 'r');
xlabel('AQ score'); ylabel('Total FI, before learning');

lm = fitlm([noise_td(:, 5); noise_asd(:, 5)], [noise_td(:, colID); noise_asd(:, colID)], 'linear');
lm.Coefficients

line = plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);
legend(line, 'p = 0.032'); ylim([5, 30]);

subplot(1, 2, 2);
scatter(noise_td(:, 6), noise_td(:, colID), 20, 'k');
hold on; grid on;
scatter(noise_asd(:, 6), noise_asd(:, colID), 20, 'r');
xlabel('SCQ score'); ylabel('Total FI, before learning');

lm = fitlm([noise_td(:, 6); noise_asd(:, 6)], [noise_td(:, colID); noise_asd(:, colID)], 'linear');
lm.Coefficients

line = plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);
legend(line, 'p = 0.0389'); ylim([5, 30]);

suptitle('Correlation, FI before learning');

%% Correlation Analysis, FI after learning
colID = 4;
figure(); subplot(1, 2, 1);
scatter(noise_td(:, 5), noise_td(:, colID), 20, 'k');
hold on; grid on;
scatter(noise_asd(:, 5), noise_asd(:, colID), 20, 'r');
xlabel('AQ score'); ylabel('Total FI, after learning');

lm = fitlm([noise_td(:, 5); noise_asd(:, 5)], [noise_td(:, colID); noise_asd(:, colID)], 'linear');
lm.Coefficients

line = plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);
legend(line, 'p = 0.042'); ylim([5, 30]);

subplot(1, 2, 2);
scatter(noise_td(:, 6), noise_td(:, colID), 20, 'k');
hold on; grid on;
scatter(noise_asd(:, 6), noise_asd(:, colID), 20, 'r');
xlabel('SCQ score'); ylabel('Total FI, after learning');

lm = fitlm([noise_td(:, 6); noise_asd(:, 6)], [noise_td(:, colID); noise_asd(:, colID)], 'linear');
lm.Coefficients

line = plot(xlim(), xlim() * lm.Coefficients.Estimate(2) + lm.Coefficients.Estimate(1), '--k', 'LineWidth', 2);
legend(line, 'p = 0.061'); ylim([5, 30]);

suptitle('Correlation, FI after learning');

%% Helper functions
function [priorPara, noisePara] = collectFit(dirWoFB, dirWFB1, dirWFB2, nSubject)

    function input = wrapOrientation(input)
        assert(sum(input > 360) == 0 && sum(input < 0) == 0);
        input(input > 180) = input(input > 180) - 180;
    end

    function idx = extractID(strName)
        idx = str2double(strName(2:3));
        if isnan(idx)
            idx = str2double(strName(2));
        end
    end

    function loadPlot(fileDir, plotOrder)
        count = 1;
        files = dir(fileDir);
        
        for file = files'
            data = load(fullfile(file.folder, file.name));
            target   = data.all_data(1, :);
            response = data.all_data(2, :);
            
            data_idx = target > 0;
            target = wrapOrientation(target(data_idx));
            response = wrapOrientation(response(data_idx));
            
            [thisScale, thisNoise] = fitExtract(target', response', 10, false, true, false, zeros(1, 3));
            priorPara(count, plotOrder + 1) = thisScale;
            noisePara(count, plotOrder + 1) = thisNoise;
            
            if plotOrder == 3
                idx = extractID(file.name);
                priorPara(count, 1) = idx;
                noisePara(count, 1) = idx;
            end
            
            count = count + 1;
        end
    end

priorPara = zeros(nSubject, 4);
noisePara = zeros(nSubject, 4);

loadPlot(dirWoFB, 1);
loadPlot(dirWFB1, 2);
loadPlot(dirWFB2, 3);

end


function plotSubject(dirWoFB, dirWFB1, dirWFB2, titleStr, saveBaseDir)

    function input = wrapOrientation(input)
        assert(sum(input > 360) == 0 && sum(input < 0) == 0);
        input(input > 180) = input(input > 180) - 180;
    end

    function idx = extractID(strName)
        idx = str2double(strName(2:3));
        if isnan(idx)
            idx = str2double(strName(2));
        end
    end

    function loadPlot(fileDir, plotOrder, titleStr, saveBaseDir)
        count = 1;
        files = dir(fileDir);
        
        for file = files'
            data = load(fullfile(file.folder, file.name));
            target   = data.all_data(1, :);
            response = data.all_data(2, :);
            
            data_idx = target > 0;
            target = wrapOrientation(target(data_idx));
            response = wrapOrientation(response(data_idx));
            
            fig = figure(count);
            subplot(1, 3, plotOrder);
            colors = get(gca,'colororder');
            
            fitExtract(target', response', 10, true, true, true, colors(plotOrder, :));
            count = count + 1;
            
            if plotOrder == 3
                idx = extractID(file.name);
                suptitle(strcat(titleStr, num2str(idx)));
                
                saveDir = fullfile(saveBaseDir, strcat(titleStr, num2str(idx)));
                print(fig, '-bestfit', saveDir, '-dpdf');
            end
        end
    end

loadPlot(dirWoFB, 1, titleStr, saveBaseDir);
loadPlot(dirWFB1, 2, titleStr, saveBaseDir);
loadPlot(dirWFB2, 3, titleStr, saveBaseDir);

end


function [scale, noise] = subjectExtractExtend(dataDir, nBins, showPlot, plotColor)

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
    
    showData = false;
    if showPlot
        figure();
    end
    [thisScale, thisNoise] = fitExtract(target', response', nBins, showPlot, true, showData, plotColor);
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
