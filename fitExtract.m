function [scale, noise] = fitExtract(allTarget, allResponse, nBins, showPlot, mirror)

if ~exist('showPlot','var')    
    showPlot = false;
end

if ~exist('mirror','var')     
      mirror = false;
end

if showPlot
    figure();
end
[average, spread, range] = extractPrior(allTarget, allResponse, nBins, mirror);
paras = expectedBias(average, spread, range, showPlot, zeros(1, 3));
scale = paras(1); noise = paras(2);

end

