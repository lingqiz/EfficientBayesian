%% Analysis
addpath('./CircStat/');
addpath('./cbrewer/');

% TD Group Level
nBootstrap = 1e4; nBins = 18; 
load('woFB_td.mat');
[scale_woFB_td, noise_woFB_td] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

load('wFB1_td.mat');
[scale_wFB1_td, noise_wFB1_td] = bootstrap(allTarget', allResponse', nBootstrap, nBins);
 
load('wFB2_td.mat');
[scale_wFB2_td, noise_wFB2_td] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

% ASD Group Level
nBootstrap = 1e4; nBins = 12;
load('woFB_asd.mat');
[scale_woFB_asd, noise_woFB_asd] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

load('wFB1_asd.mat');
[scale_wFB1_asd, noise_wFB1_asd] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

load('wFB2_asd.mat');
[scale_wFB2_asd, noise_wFB2_asd] = bootstrap(allTarget', allResponse', nBootstrap, nBins);

%% changes in prior, control
% Statistical Tests
diffDist = scale_woFB_td - scale_wFB2_td;
testStat = mean(diffDist)
nullStat = diffDist - testStat;
std(nullStat)
sum(nullStat > testStat) / nBootstrap

%% changes in prior, asd
diffDist = scale_woFB_asd - scale_wFB2_asd;
testStat = mean(diffDist)
nullStat = diffDist - testStat;
std(nullStat)
sum(abs(nullStat) > testStat) / nBootstrap

%% prior before feedback
diffDist = scale_woFB_asd - scale_woFB_td;
testStat = mean(diffDist)
nullStat = diffDist - testStat;
std(nullStat)
sum(abs(nullStat) > abs(testStat)) / nBootstrap

%% prior change from woFB to wFB2
diffStat = (scale_woFB_td - scale_wFB2_td) - (scale_woFB_asd - scale_wFB2_asd);
testStat = mean(diffStat)
nullStat = diffStat - testStat;
std(nullStat)
sum(abs(nullStat) > testStat) / nBootstrap

%% total fisher information
diffStat = noise_woFB_td - noise_woFB_asd;
testStat = mean(diffStat)
nullDist = diffStat - testStat;
std(nullDist)
sum(nullDist > testStat) / nBootstrap

%% control fisher change
diffDist = noise_wFB2_td - noise_woFB_td;
testStat = mean(diffDist)
nullDist = diffDist - testStat;
std(nullDist)
sum(nullDist > testStat) / nBootstrap

%% asd fisher change
diffDist = noise_wFB2_asd - noise_woFB_asd;
testStat = mean(diffDist)
nullDist = diffDist - testStat;
std(nullDist)
sum(abs(nullDist) > abs(testStat)) / nBootstrap

%% fisher
mean(noise_woFB_td)
std(noise_woFB_td)

mean(noise_woFB_asd)
std(noise_woFB_asd)

%% Plot Parameter Change
figure; subplot(1, 2, 1);
hold on; grid on;
errorbar([0.8, 2, 3.2], mean([scale_woFB_td; scale_wFB1_td; scale_wFB2_td], 2), ...
    std([scale_woFB_td; scale_wFB1_td; scale_wFB2_td], 0, 2), '--o', 'LineWidth', 2);

errorbar([0.8, 2, 3.2], mean([scale_woFB_asd; scale_wFB1_asd; scale_wFB2_asd], 2), ...
    std([scale_woFB_asd; scale_wFB1_asd; scale_wFB2_asd], 0, 2), '--o', 'LineWidth', 2);
legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]); ylim([0, 0.8]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Prior Weight $$ \omega $$', 'interpreter', 'latex')

subplot(1, 2, 2);
hold on; grid on;
errorbar([0.8, 2, 3.2], mean([noise_woFB_td; noise_wFB1_td; noise_wFB2_td], 2), ...
    std([noise_woFB_td; noise_wFB1_td; noise_wFB2_td], 0, 2), '--o', 'LineWidth', 2);

errorbar([0.8, 2, 3.2], mean([noise_woFB_asd; noise_wFB1_asd; noise_wFB2_asd], 2), ...
    std([noise_woFB_asd; noise_wFB1_asd; noise_wFB2_asd], 0, 2), '--o', 'LineWidth', 2);

legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Total $$ \sqrt{J(\theta)} $$', 'interpreter', 'latex')

%% Helper (bootstrap) function
function [scale, noise] = bootstrap(allTarget, allResponse, nBootstrap, nBins)
    scale = zeros(1, nBootstrap);
    noise = zeros(1, nBootstrap);
    
    parfor idx = 1:nBootstrap
        [target, response] = resample(allTarget, allResponse);
        [scale(idx), noise(idx)] = fitExtract(target, response, nBins);
    end
end