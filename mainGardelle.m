%% Data exploration, bias plot
load('DeGardelleData.mat');
dataMtx = dataMtx(dataMtx(:, 1) ~= 0, :);
dataMtx = dataMtx(mod(dataMtx(:, 2), 45) ~= 0, :);
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
    subplot(2, 3, idx);
    subData = dataMtx(dataMtx(:, 1) == targetCond(idx), :);
    
    scatter(subData(:, 2), subData(:, 3), 0.5);    
    xlim([0, 180]); ylim(ylimCond(idx, :));
    xlabel('Orientation'); ylabel('Bias');
    title('All Bias'); grid on;
end

subplot(2, 3, 6);
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.5);
xlim([0, 180]); ylim([-90, 90]);
xlabel('Orientation'); ylabel('Bias');
title('All Bias');

%% Data exploration, density plot
figure();
target = dataMtx(:, 2);
response = dataMtx(:, 3);
[bandwidth, density, X, Y, min_xy, max_xy]= kde2d([target, response]);
surf(X, Y, density);
xlim([0, 180]); ylim([-90, 90]); view([0, 90]);

figure(); hold on;
contour(X, Y, density);
xlim([0, 180]); ylim([-90, 90]); view([0, 90]);
plotReference();

figure();
for idx = 1:length(targetCond)
    subplot(2, 3, idx)
    subData = dataMtx(dataMtx(:, 1) == targetCond(idx), [2, 3]);
    [bandwidth, density, X, Y]= kde2d(subData, 256, min_xy, max_xy);
    
    surf(X,Y,density);
    xlim([0, 180]); ylim([-90, 90]); view([0, 90]);    
end

subplot(2, 3, 6)
target = dataMtx(:, 2);
response = dataMtx(:, 3);
[~, density, X, Y]= kde2d([target, response]);
surf(X, Y, density);
xlim([0, 180]); ylim([-90, 90]); view([0, 90]);

%% Fit combined data
fitData(dataMtx);

%% Visualization
estimator = BayesianEstimator(1.0, 2.0);
estimator.computeEstimator();

figure(); hold on;
[thetas, bias, densityGrid] = estimator.visualizeGrid('ShowPlot', false);
imagesc(thetas, bias, densityGrid); colorbar();
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.25);
plotReference();
xlim([0, 180]); ylim([-90, 90]);
title('Bias');

figure(); hold on;
[thetas, bias, densityGrid] = estimator.visualizeGrid('ShowPlot', false);
[X, Y] = meshgrid(thetas, bias);
contour(X, Y, densityGrid, 15);
plotReference();

figure(); hold on;
[thetas, bias, densityGrid] = estimator.visualizeGrid('ShowPlot', false);
imagesc(thetas, bias, densityGrid); colorbar();
[thetas, estimate, biasLB, biasUB] = estimator.visualizeCurve();
plotReference();
xlim([0, 180]); ylim([-90, 90]);
title('Bias');

figure(); hold on; grid on;
plot(thetas, biasUB - biasLB, 'k', 'LineWidth', 2); yRange = ylim();
plotReference();
ylim(yRange); title('Range of Estimate');

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
[thetas, bias, densityGrid] = estimator.visualizeGrid('ShowPlot', false);
imagesc(thetas, bias, densityGrid);
scatter(dataMtx(:, 2), dataMtx(:, 3), 0.25, colors(1, :));
xlim([0, 180]); ylim([-90, 90]);
title('Bias');
end

function plotReference()
    plot([45, 45], [-90, 90], '--k', 'LineWidth', 2);
    plot([90, 90], [-90, 90], '--k', 'LineWidth', 2);
    plot([135, 135], [-90, 90], '--k', 'LineWidth', 2);    
end
