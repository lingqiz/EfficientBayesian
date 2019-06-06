classdef BayesianEstimator < handle
    % Bayesian estimator with efficient encoding for modeling (circular) orientation estimate.
    
    properties (Access = public)
        prior;     % Prior distribution p(theta)
        intNoise;  % Size of internal noise (kappa)
        stmSpc;    % Stimulus space [0, 2 * pi]
        snsSpc;    % Sensory space [0, 2 * pi]
    end
    
    properties (Access = private)        
        stepSize;  % Increments for discretization
        
        mapping;   % Mapping from stimulus space to sensory space
        estimates; % Estimates as a function of measurements
        
        ivsStmSpc; % Points in the stimulus space corresponds to the uniform sensory space
        ivsPrior;  % Prior defined on the vector ivsStmSpc
    end
    
    methods (Access = public)
        function this = BayesianEstimator(priorScale, intNoise, varargin)
            % Constructor for the Bayesian estimator with prior and noise parameter
            
            % Prase and save input parameters
            p = inputParser;
            p.addParameter('StepSize', 0.01, @(x)(isnumeric(x) && numel(x) == 1));
            p.addParameter('PriorHandle', priorHandle(priorScale), @(x) isa(x, 'function_handle'))
            
            parse(p, varargin{:});
            this.stepSize = p.Results.StepSize;
            this.stmSpc = 0 : this.stepSize : 2 * pi;
            this.snsSpc = 0 : this.stepSize : 2 * pi;
            this.prior = p.Results.PriorHandle;
            this.intNoise = intNoise;
        end
        
        function this = computeEstimator(this)
            % Compute the estimator mapping theta_hat(measurement) for the entire domain
            % Should recalculate after changing the prior or the noise parameter
            priorDnst = this.prior(this.stmSpc);
            this.mapping   = cumtrapz(this.stmSpc, priorDnst) * 2 * pi;
            this.ivsStmSpc = interp1(this.mapping, this.stmSpc, this.snsSpc, 'linear', 'extrap');
            this.ivsPrior  = this.prior(this.ivsStmSpc);
            
            % Calculate an estimate for the entire sensory space
            this.estimates = zeros(1, length(this.snsSpc));
            for idx = 1:length(this.snsSpc)
                this.estimates(idx) = this.thetaEstimator(this.snsSpc(idx));
            end
        end
        
        function estimate = thetaEstimator(this, snsMsmt)
            % Calculate theta_hat given the sensory measurement
            likelihood = vonmpdf(this.snsSpc, snsMsmt, this.intNoise);
            score = likelihood .* this.ivsPrior;
            
            stmScore = interp1(this.ivsStmSpc, score, this.stmSpc, 'linear', 'extrap');
            
            % L2 loss, posterior mean
            posteriorDist = stmScore / trapz(this.stmSpc, stmScore);
            posteriorMass = posteriorDist * this.stepSize;
            
            % Calculate circular mean with helper function
            estimate = circularMean(this.stmSpc, posteriorMass);
        end
        
        function [domain, probDnst] = estimatePDF(this, theta)
            % Return the distribution of estimate p(theta_hat | theta)
            
            % Measurement distribution
            thetaTilde = interp1(this.stmSpc, this.mapping, theta, 'linear', 'extrap');
            msmtDist = vonmpdf(this.snsSpc, thetaTilde, this.intNoise);
            
            % Change of variable from measurement to estimate
            probDnst = abs(gradient(this.snsSpc, this.estimates)) .* msmtDist;
            
            domain = this.stmSpc;
            probDnst = interp1(this.estimates, probDnst, domain, 'linear', 'extrap');
        end
                
        function [thetas, bias, biasLB, biasUB] = visualization(this, varargin)
            % Visualize the bias and distribution of estimates pattern
            p = inputParser;
            p.addParameter('StepSize', 0.05, @(x)(isnumeric(x) && numel(x) == 1));
            p.addParameter('Interval', 0.68, @(x)(isnumeric(x) && numel(x) == 1));
            p.addParameter('Parallel', false, @(x) isa(x, 'logical'));
            parse(p, varargin{:});
            
            init = 0.01; ci = p.Results.Interval;
            thetas = init : p.Results.StepSize : 2 * pi;
            
            estimate   = zeros(1, length(thetas));
            estimateLB = zeros(1, length(thetas));
            estimateUB = zeros(1, length(thetas));
            
            if p.Results.Parallel
                parfor idx = 1:length(thetas)
                    [ests, prob] = this.estimatePDF(thetas(idx));
                    estimate(idx) = circularMean(ests, prob * this.stepSize);
                    
                    [estimateLB(idx), estimateUB(idx)] = ...
                        this.intervalEstimate(ests, prob, thetas(idx), ci);
                end
            else
                for idx = 1:length(thetas)
                    [ests, prob] = this.estimatePDF(thetas(idx));
                    estimate(idx) = circularMean(ests, prob * this.stepSize);
                    
                    [estimateLB(idx), estimateUB(idx)] = ...
                        this.intervalEstimate(ests, prob, thetas(idx), ci);
                end
            end
                        
            bias   = (estimate - thetas) / (2 * pi) * 180;
            biasLB = (estimateLB - thetas) / (2 * pi) * 180;
            biasUB = (estimateUB - thetas) / (2 * pi) * 180;
            thetas = thetas / (2 * pi) * 180;
        end
        
    end
    
    methods (Access = private)                
        
        function [estLB, estUB] = intervalEstimate(~, support, probDnst, theta, ci)
            % Helper function for plotting the distribution of estimates
            if(theta < 0.5 * pi)
                support(support > pi) = support(support > pi) - 2 * pi;
            elseif(theta > 1.5 * pi)
                support(support < pi) = support(support < pi) + 2 * pi;
            end
            [support, sortIdx] = sort(support);
            probDnst = probDnst(sortIdx);
            support  = support(probDnst > 0);
            probDnst = probDnst(probDnst > 0);
            
            [cdf, uIdx] = unique(cumtrapz(support, probDnst), 'stable');
            quantileLB = (1 - ci) / 2;
            quantileUB = 1 - quantileLB;
            
            estLB = interp1(cdf, support(uIdx), quantileLB);
            estUB = interp1(cdf, support(uIdx), quantileUB);
        end
        
    end
    
end