%% TD Group Level
nBins = 10; showPlot = true;
load('woFB_td.mat');
[scale_woFB_td, noise_woFB_td] = extractPrior(allTarget', allResponse', nBins, showPlot);
suptitle('TD woFB');

load('wFB1_td.mat');
[scale_wFB1_td, noise_wFB1_td] = extractPrior(allTarget', allResponse', nBins, showPlot);
suptitle('TD wFB1');

load('wFB2_td.mat');
[scale_wFB2_td, noise_wFB2_td] = extractPrior(allTarget', allResponse', nBins, showPlot);
suptitle('TD wFB2');

%% ASD Group Level
nBins = 10; showPlot = true;
load('woFB_asd.mat');
[scale_woFB_asd, noise_woFB_asd] = extractPrior(allTarget', allResponse', nBins, showPlot);
suptitle('ASD woFB');

load('wFB1_asd.mat');
[scale_wFB1_asd, noise_wFB1_asd] = extractPrior(allTarget', allResponse', nBins, showPlot);
suptitle('ASD wFB1');

load('wFB2_asd.mat');
[scale_wFB2_asd, noise_wFB2_asd] = extractPrior(allTarget', allResponse', nBins, showPlot);
suptitle('ASD wFB2');

%% Plot Parameter Change
figure; subplot(1, 2, 1);
hold on; grid on;
plot([0.8, 2, 3.2], [scale_woFB_td,  scale_wFB1_td,  scale_wFB2_td], '--o', 'LineWidth', 2);
plot([0.8, 2, 3.2], [scale_woFB_asd, scale_wFB1_asd, scale_wFB2_asd], '--o', 'LineWidth', 2);
legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]); ylim([0, 0.8]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Prior Parameter');

subplot(1, 2, 2);
hold on; grid on;
plot([0.8, 2, 3.2], [1/noise_woFB_td,  1/noise_wFB1_td,  1/noise_wFB2_td], '--o', 'LineWidth', 2);
plot([0.8, 2, 3.2], [1/noise_woFB_asd, 1/noise_wFB1_asd, 1/noise_wFB2_asd], '--o', 'LineWidth', 2);

legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]); 
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Internal Noise Parameter');
