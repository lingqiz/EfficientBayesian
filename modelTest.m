%% Bias pattern
% Create estimator with prior parameter and internal noise parameter
estimator = BayesianEstimator(1.8, 1);
estimator.computeEstimator();

[thetas, bias] = estimator.visualization();

figure; hold on; grid on;
plot(thetas, bias, 'LineWidth', 2);

% Use different parameters
estimator = BayesianEstimator(1.8, 2.5);
estimator.computeEstimator();

[thetas, bias] = estimator.visualization();
plot(thetas, bias, 'LineWidth', 2);

% Use different parameters
estimator = BayesianEstimator(1.8, 5);
estimator.computeEstimator();

[thetas, bias] = estimator.visualization();
plot(thetas, bias, 'LineWidth', 2);

xlabel('Orientation (deg)'); ylabel('Bias (deg)');

%% Full distribution pattern
figure; hold on;
colors = get(gca, 'colororder');

subplot(2, 1, 1); grid on;
estimator = BayesianEstimator(1.5, 10);
estimator.computeEstimator();

[theta, bias, lb, ub] = estimator.visualization();
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(1, :));

subplot(2, 1, 2); grid on;
estimator = BayesianEstimator(1.8, 5);
estimator.computeEstimator();

[theta, bias, lb, ub] = estimator.visualization('Interval', 0.95);
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(2, :));

xlabel('Orientation (deg)'); ylabel('Bias (deg)');
