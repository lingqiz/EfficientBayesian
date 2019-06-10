%% TD Group
load('woFB_td.mat');
init = [1.8, 5];
target_woFB = allTarget; response_woFB = allResponse;
[para_td_woFB, fval_td_woFB] = optWrapper(init, target_woFB, response_woFB, 'Optimizer', 'bads');

load('wFB1_td.mat');
init = [1.6, 5];
target_wFB1 = allTarget; response_wFB1 = allResponse;
[para_td_wFB1, fval_td_wFB1] = optWrapper(init, target_wFB1, response_wFB1, 'Optimizer', 'bads');

load('wFB2_td.mat');
init = [1.5, 5];
target_wFB2 = allTarget; response_wFB2 = allResponse;
[para_td_wFB2, fval_td_wFB2] = optWrapper(init, target_wFB2, response_wFB2, 'Optimizer', 'bads');

%% ASD Group
load('woFB_asd.mat');
init = [1.8, 5];
target_woFB = allTarget; response_woFB = allResponse;
[para_asd_woFB, fval_asd_woFB] = optWrapper(init, target_woFB, response_woFB, 'Optimizer', 'bads');

load('wFB1_asd.mat');
init = [1.6, 5];
target_wFB1 = allTarget; response_wFB1 = allResponse;
[para_asd_wFB1, fval_asd_wFB1] = optWrapper(init, target_wFB1, response_wFB1, 'Optimizer', 'bads');

load('wFB2_asd.mat');
init = [1.5, 5];
target_wFB2 = allTarget; response_wFB2 = allResponse;
[para_asd_wFB2, fval_asd_wFB2] = optWrapper(init, target_wFB2, response_wFB2, 'Optimizer', 'bads');

%% Plot Parameter Change
figure; subplot(2, 1, 1);
hold on; grid on;
plot([0.8, 2, 3.2], [para_td_woFB(1),  para_td_wFB1(1),  para_td_wFB2(1)], '--o', 'LineWidth', 2);
plot([0.8, 2, 3.2], [para_asd_woFB(1), para_asd_wFB1(1), para_asd_wFB2(1)], '--o', 'LineWidth', 2);
legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Prior Parameter');

subplot(2, 1, 2);
hold on; grid on;
plot([0.8, 2, 3.2], sqrt([1/para_td_woFB(2),  1/para_td_wFB1(2),  1/para_td_wFB2(2)]), '--o', 'LineWidth', 2);
plot([0.8, 2, 3.2], sqrt([1/para_asd_woFB(2), 1/para_asd_wFB1(2), 1/para_asd_wFB2(2)]), '--o', 'LineWidth', 2);

legend({'Normal', 'ASD'});
xlim([0.5, 3.5]); xticks([0.8, 2, 3.2]);
xticklabels({'woFB', 'wFB1', 'wFB2'});
title('Internal Noise Parameter');

%% Model - Data scatter Plot, Control
convertBias = @(x) wrapToPi(x / 180 * (2 * pi)) / (2 * pi) * 180;

figure(1);
colors = get(gca, 'colororder');

load('woFB_td.mat');
estimator = BayesianEstimator(para_td_woFB(1), para_td_woFB(2));
estimator.computeEstimator();
[theta, bias, lb, ub] = estimator.visualization('Interval', 0.95);

subplot(1, 2, 1); hold on; grid on;
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(1, :));
scatter(allTarget, convertBias(allResponse - allTarget), 0.5, colors(1, :));
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation (deg)'); ylabel('Bias (deg)');
title('Bias, Control - woFB');

figure(2); subplot(1, 2, 1); hold on;
estimator.visualizeGrid();
scatter(allTarget, convertBias(allResponse - allTarget), 0.25, colors(1, :));
title('Bias, Control - woFB');

figure(1); load('wFB2_td.mat');
estimator = BayesianEstimator(para_td_wFB2(1), para_td_wFB2(2));
estimator.computeEstimator();
[theta, bias, lb, ub] = estimator.visualization('Interval', 0.95);

subplot(1, 2, 2); hold on; grid on;
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(2, :));
scatter(allTarget, convertBias(allResponse - allTarget), 0.5, colors(2, :));
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation (pi)'); ylabel('Bias (deg)');
title('Bias, Control - wFB2');

figure(2); subplot(1, 2, 2); hold on;
estimator.visualizeGrid();
scatter(allTarget, convertBias(allResponse - allTarget), 0.25, colors(1, :));
title('Bias, Control - wFB2');

%% Model - Data scatter Plot, ASD
figure(3);
colors = get(gca, 'colororder');

load('woFB_asd.mat');
estimator = BayesianEstimator(para_asd_woFB(1), para_asd_woFB(2));
estimator.computeEstimator();
[theta, bias, lb, ub] = estimator.visualization('Interval', 0.95);

subplot(1, 2, 1); hold on; grid on;
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(1, :));
scatter(allTarget, allResponse - allTarget, 0.5, colors(1, :));
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation deg)'); ylabel('Bias (deg)');
title('Bias, ASD - woFB');

figure(4); subplot(1, 2, 1); hold on;
estimator.visualizeGrid();
scatter(allTarget, convertBias(allResponse - allTarget), 0.25, colors(1, :));
title('Bias, ASD - woFB');

figure(3); load('wFB2_asd.mat');
estimator = BayesianEstimator(para_asd_wFB2(1), para_asd_wFB2(2));
estimator.computeEstimator();
[theta, bias, lb, ub] = estimator.visualization('Interval', 0.95);

subplot(1, 2, 2); hold on; grid on;
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(2, :));
scatter(allTarget, allResponse - allTarget, 0.5, colors(2, :));
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation (deg)'); ylabel('Bias (deg)');
title('Bias, ASD - wFB2');

figure(4); subplot(1, 2, 2); hold on;
estimator.visualizeGrid();
scatter(allTarget, convertBias(allResponse - allTarget), 0.25, colors(1, :));
title('Bias, ASD - wFB2');
