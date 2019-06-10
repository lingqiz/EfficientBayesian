%% Bias pattern
% Create estimator with prior parameter and internal noise parameter
estimator = BayesianEstimator(1, 5);
estimator.computeEstimator();

subplot(2, 1, 1); hold on; grid on;
plot(estimator.stmSpc / (2 * pi) * 180, estimator.prior(estimator.stmSpc), 'k', 'LineWidth', 2);
xlabel('Orientation (deg)'); ylabel('Probability Density');

subplot(2, 1, 2); hold on; grid on;
[thetas, bias] = estimator.visualization();
plot(thetas, bias, 'LineWidth', 2);

% Use different parameters
estimator = BayesianEstimator(1, 2);
estimator.computeEstimator();

[thetas, bias] = estimator.visualization();
plot(thetas, bias, 'LineWidth', 2);

% Use different parameters
estimator = BayesianEstimator(1, 0.5);
estimator.computeEstimator();

[thetas, bias] = estimator.visualization();
plot(thetas, bias, 'LineWidth', 2);

xlabel('Orientation (deg)'); ylabel('Bias (deg)');
legend({'low noise', 'mid noise', 'high noise'});

%% Full distribution pattern
figure; hold on;
colors = get(gca, 'colororder');

% Use different parameters
subplot(2, 1, 1); grid on;
estimator = BayesianEstimator(1.0, 2.5);
estimator.computeEstimator();

[theta, bias, lb, ub] = estimator.visualization();
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(1, :));

% Use different parameters
subplot(2, 1, 2); grid on;
estimator = BayesianEstimator(1.0, 1);
estimator.computeEstimator();

[theta, bias, lb, ub] = estimator.visualization();
errorbar(theta, bias, bias - lb, ub - bias, 'LineWidth', 1.0, 'Color', colors(2, :));

xlabel('Orientation (deg)'); ylabel('Bias (deg)');

%% Full distribution pattern, density plot
% Use different parameters
figure();
estimator = BayesianEstimator(1.0, 2);
estimator.computeEstimator();

estimator.visualizeGrid('StepSize', 0.05);

% Use different parameters
figure();
estimator = BayesianEstimator(1.0, 1);
estimator.computeEstimator();

estimator.visualizeGrid('StepSize', 0.05);

%% Test for fitting the data
figure(); subplot(1, 2, 1);
estimator = BayesianEstimator(0.5, 6);
estimator.computeEstimator();
estimator.visualizeGrid('Clim', [0, 1.6]);

subplot(1, 2, 2);
estimator = BayesianEstimator(1.5, 6);
estimator.computeEstimator();
estimator.visualizeGrid('Clim', [0, 1.6]);
