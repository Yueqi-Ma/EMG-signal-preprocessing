function [IN_abs, targets] = processEMGFiles(txtFilePaths)
    numFiles = numel(txtFilePaths);
    
    IN = [];
    targets = [];
    
    for i = 1:numFiles
        txtFilePath = txtFilePaths{i};
        In = calculateIn(txtFilePath);
        
        IN = [IN; In];
        
        rows = size(In, 1);
        target = zeros(rows, numFiles);
        target(:, i) = 1;
        
        targets = [targets; target];
    end
    
    IN_abs = abs(IN);
    writematrix(IN_abs, 'IN_abs.txt', 'Delimiter', ';');
    
    writematrix(targets, 'Targets.txt', 'Delimiter', ';');
end
