clc;
clear
close all;
%%
% txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/group/BlueBCI-2023-12-24-15-33-08/A9.txt';
 txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/YS_train_data/5YS/A9.txt';
% txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/index finger/BlueBCI-2023-12-24-16-56-00/A9.txt';
%txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/8/BlueBCI-2024-01-22-15-58-24/A9.txt';
%txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt';
%txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt';
%txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt';
% txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/ring_little/BlueBCI-2023-12-24-17-37-57/A9.txt';
% %data = readmatrix(txtFilePath);



%%
%txtFilePaths = {
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/thumb/BlueBCI-2023-12-24-16-10-51/A9.txt',
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/index finger/BlueBCI-2023-12-24-16-56-00/A9.txt',
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/middle finger/BlueBCI-2023-12-24-17-14-19/A9.txt',
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/ring_little/BlueBCI-2023-12-24-17-37-57/A9.txt',
    
%     'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/2/BlueBCI-2024-01-22-14-26-01/A9.txt',
%     'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/6/BlueBCI-2024-01-22-16-16-21/A9.txt',
%     'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/8/BlueBCI-2024-01-22-15-58-24/A9.txt',
%     'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/lateral grip/BlueBCI-2024-01-23-11-57-00/A9.txt',
%     'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/OK/BlueBCI-2024-01-22-14-02-13/A9.txt',
%     'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/spoon/BlueBCI-2024-01-23-12-27-12/A9.txt',

    
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt',
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/2/BlueBCI-2024-01-23-16-25-16/A9.txt',
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/3/BlueBCI-2024-01-23-16-47-38/A9.txt',
%    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/YS_train_data/5YS/A9.txt'};

    %%
%     numFiles = numel(txtFilePaths);
%       
%     for i = 1:numFiles
%         txtFilePath = txtFilePaths{i};
%     end



%%
X = calculateIn(txtFilePath);
X=abs(X);
[Yd, Xf, Af] = myNeuralNetwork14Function(X, [], []);%%%%Change the Neural network modle here!!!
%disp([Yd]);
Y = round(Yd);  
%disp([Y]);

%%
ID = zeros(size(Y, 1), 1);  % 创建与 Y 行数相同的列向量 ID

for i = 1:size(Y, 1)
    
    rowVector = Y(i, :);  % 获取 Y 的第 i 行行向量
    columnIndex = find(rowVector == 1);  % 查找元素为 1 的列索引
    
     if isempty(columnIndex)|| (size(columnIndex,2)>1)
        ID(i, :) = 0;
     else
        ID(i,:) = columnIndex;  % 将列索引赋值给 ID 的对应位置
     end
    
end

%disp([ID]);


%%
histogram(ID);  % 显示分类结果的分布情况
pie(ID);        % 使用饼图显示分类结果的占比
%confusionchart(Y, predictedLabels);  % 显示混淆矩阵
%confusionchart(Y,ID);  % 显示混淆矩阵

