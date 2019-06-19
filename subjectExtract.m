function [scale, noise] = subjectExtract(dataDir, nBins, showPlot)

    function input = wrapOrientation(input)
        assert(sum(input > 360) == 0 && sum(input < 0) == 0);
        input(input > 180) = input(input > 180) - 180;
    end

files = dir(dataDir);

scale = [];
noise = [];
for file = files'
    data = load(fullfile(file.folder, file.name));
    target   = data.all_data(1, :);
    response = data.all_data(2, :);
    
    data_idx = target > 0;
    target = wrapOrientation(target(data_idx));
    response = wrapOrientation(response(data_idx));
    
    [thisScale, thisNoise] = extractPrior(target', response', nBins, showPlot);
    scale = [scale, thisScale];
    noise = [noise, thisNoise];
end

end