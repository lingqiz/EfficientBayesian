%% Data Preprocessing
load('DeGardelleData.mat');
dataMtx = dataMtx(dataMtx(:, 1) ~= 0, :);
convertBias = @(x) wrapToPi(x / 180 * (2 * pi)) / (2 * pi) * 180;

figure();
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.5);
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation'); ylabel('Bias');
title('All Bias');

figure();
targetCond = [20, 40, 80, 160, 1000];
ylimCond = [-90, 90; -90, 90; -50, 50; -50, 50; -50, 50];
for idx = 1:length(targetCond)
    subplot(5, 1, idx);
    subData = dataMtx(dataMtx(:, 1) == targetCond(idx), :);
    
    scatter(subData(:, 2), subData(:, 3), 0.5);
    xlim([0, 180]); ylim(ylimCond(idx, :));
    xlabel('Orientation'); ylabel('Bias');
    title('All Bias'); grid on;
end

%% Fit combined data
fitData(dataMtx);

%% Visualization
estimator = BayesianEstimator(1.5, 1.0);
estimator.computeEstimator();

figure(); hold on;
[thetas, bias, densityGrid] = estimator.visualizeGrid('ShowPlot', false);
imagesc(thetas, bias, densityGrid);
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.25);
xlim([0, 180]); ylim([-90, 90]);
title('Bias');

%% Fit seperate condition
targetCond = [20, 40, 80, 160, 1000];
for idx = 1:length(targetCond)    
    subData = dataMtx(dataMtx(:, 1) == targetCond(idx), :);
    fitData(subData);
end

%% Helper function
function fitData(dataMtx)

init = [1.0, 5];
[para, ~] = optWrapper(init, dataMtx(:, 2), dataMtx(:, 4), 'Optimizer', 'fminsearch');

figure();
colors = get(gca, 'colororder');

estimator = BayesianEstimator(para(1), para(2));
estimator.computeEstimator();
[theta, bias, lb, ub] = estimator.visualization('Interval', 0.95);

hold on; grid on;
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(1, :));
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.25, colors(1, :));
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation (deg)'); ylabel('Bias (deg)');
title('Bias');

figure(); hold on;
estimator.visualizeGrid();
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.25, colors(1, :));
title('Bias');
end
