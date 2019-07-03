function [scale, noise] = fitExtract(allTarget, allResponse, nBins, showPlot, mirror, plotData, plotColor)

if ~exist('showPlot','var')    
    showPlot = false;
end

if ~exist('plotData','var')    
    plotData = false;
end

if ~exist('mirror','var')     
      mirror = false;
end

[average, spread, range] = extractPrior(allTarget, allResponse, nBins, mirror, plotData, plotColor);
paras = expectedBias(average, spread, range, showPlot, plotColor);
scale = paras(1); noise = paras(2);

end

