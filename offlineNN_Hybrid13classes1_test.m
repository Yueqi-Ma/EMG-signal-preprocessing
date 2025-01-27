clc;
clear
close all;
%%
%txtFilePath= 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/group/BlueBCI-2023-12-24-15-33-08/A9.txt';
%txtFilePath = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/ring_little/BlueBCI-2023-12-24-17-37-57/A9.txt';
 txtFilePath ='D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt';
% txtFilePath = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/2/BlueBCI-2024-01-23-16-25-16/A9.txt';
% txtFilePath = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/3/BlueBCI-2024-01-23-16-47-38/A9.txt';

%txtFilePath = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_subjects/YS_8actions/A9.txt';


%data = readmatrix(txtFilePath);
%%

X = calculateIn(txtFilePath);

datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
X=X(1, :);
%X = readmatrix(txtFilePath);
X=abs(X);
[Yd, Xf, Af] = myNeuralNetworkFunction_hybrid13classes1(X, [], []);
%disp([Yd]);
Y = round(Yd);  
%disp([Y]);
datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
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
%histogram(Y);  % 显示分类结果的分布情况
%pie(Y);        % 使用饼图显示分类结果的占比
%confusionchart(Y, predictedLabels);  % 显示混淆矩阵
%confusionchart(Y,ID);  % 显示混淆矩阵

