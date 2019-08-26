%% TD Group
nBins = 12; showPlot = true;
figure(1); colors = get(gca,'colororder');

load('woFB_td.mat');
subplot(3, 3, 1);
[average, spread, range] = extractPrior(allTarget', allResponse', nBins, false, false, colors(1, :));
paras_woFB_td = expectedBias(average, spread, range, showPlot, colors(1, :));
plotExtract(spread, paras_woFB_td(1), range, [4, 7], colors(1, :)); 

load('wFB1_td.mat');
subplot(3, 3, 2);
[average, spread, range] = extractPrior(allTarget', allResponse', nBins, false, false, colors(2, :));
paras_wFB1_td = expectedBias(average, spread, range, showPlot, colors(2, :));
plotExtract(spread, paras_wFB1_td(1), range, [5, 8], colors(2, :));
load('wFB2_td.mat');
subplot(3, 3, 3);
[average, spread, range] = extractPrior(allTarget', allResponse', nBins, false, false, colors(3, :));
paras_wFB2_td = expectedBias(average, spread, range, showPlot, colors(3, :));
plotExtract(spread, paras_wFB2_td(1), range, [6, 9], colors(3, :));

suptitle('TD Group');

%% ASD Group
nBins = 12; showPlot = true;
figure(2); colors = get(gca,'colororder');

load('woFB_asd.mat');
subplot(3, 3, 1);
[average, spread, range] = extractPrior(allTarget', allResponse', nBins, false, false, colors(1, :));
paras_woFB_asd = expectedBias(average, spread, range, showPlot, colors(1, :));
plotExtract(spread, paras_woFB_asd(1), range, [4, 7], colors(1, :));
load('wFB1_asd.mat');
subplot(3, 3, 2);
[average, spread, range] = extractPrior(allTarget', allResponse', nBins, false, false, colors(2, :));
paras_wFB1_asd = expectedBias(average, spread, range, showPlot, colors(2, :));
plotExtract(spread, paras_wFB1_asd(1), range, [5, 8], colors(2, :));
load('wFB2_asd.mat');
subplot(3, 3, 3);
[average, spread, range] = extractPrior(allTarget', allResponse', nBins, false, false, colors(3, :));
paras_wFB2_asd = expectedBias(average, spread, range, showPlot, colors(3, :));
plotExtract(spread, paras_wFB2_asd(1), range, [6, 9], colors(3, :));

suptitle('ASD Group');

%% Helper Function
function plotExtract(spread, scale, range, idx, lineColor)
subplot(3, 3, idx(1));

plot(range, abs(spread), 'k', 'LineWidth', 2, 'Color', lineColor);
grid on; xlim([0, 2 * pi]);  ylim([0.05, 0.4]);
title('1/Kappa');

subplot(3, 3, idx(2));

priorDist = priorHandle(scale);
domain = 0 : 0.025 : 2 * pi;

plot(domain, priorDist(domain), 'LineWidth', 2, 'Color', lineColor);
grid on; xlim([0, 2 * pi]);
title('Fisher Information'); ylim([0.0, 0.35]);
end