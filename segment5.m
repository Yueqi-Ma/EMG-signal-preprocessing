% 读取信号数据文件
clear; clc;
file_path = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/thumb/BlueBCI-2023-12-24-16-10-51/A9.txt';
data = readmatrix(file_path);

% 采样率为1000Hz，每秒1000个采样点
fs = 1000;

% 去除前13秒（前13000行）的采样数据
data = data(13001:end, :);

% 去除指定的列
columns_to_remove = [1, 5, 7, 8, 10, 11, 12];
data(:, columns_to_remove) = [];

% 初始化分割后的信号数据
segmented_data = [];

% 定义每个循环的保留时间和去除时间
action = 3 * fs;  % 三秒（3000行）
rest = 2 * fs;  % 两秒（2000行）

% 获取数据的总行数
total_rows = size(data, 1);

% 进行循环分割
for i = 1:rest+action:total_rows
    if i + rest+action - 1 <= total_rows
        % 保留指定时间的数据
        %disp(i)
        %disp(segmented_data)
        segmented_data = [segmented_data; data(i:i+action-1, :)];
    end
end
% 保留前300,000行的数据
if size(segmented_data, 1) > 300000
    segmented_data = segmented_data(1:300000, :);
end

% 将分割后的数据保存到不同的变量中
sensor1 = segmented_data(:, 1);
sensor2 = segmented_data(:, 2);
sensor3 = segmented_data(:, 3);
sensor4 = segmented_data(:, 4);
sensor5 = segmented_data(:, 5);

% 保存每个传感器的数据为文本文件，使用分号作为分隔符
writematrix(sensor1, 'sensor1.txt', 'Delimiter', ';');
writematrix(sensor2, 'sensor2.txt', 'Delimiter', ';');
writematrix(sensor3, 'sensor3.txt', 'Delimiter', ';');
writematrix(sensor4, 'sensor4.txt', 'Delimiter', ';');
writematrix(sensor5, 'sensor5.txt', 'Delimiter', ';');

disp('分割后的数据已保存为 sensor1.txt, sensor2.txt, sensor3.txt, sensor4.txt, sensor5.txt 文件。');
% 将五个传感器的列向量按顺序组合成一个列向量


% 初始化结果向量
a = [];

% 提取数据并组成行向量
for i = 1:3000:size(sensor1, 1)
    % 提取每个传感器的数据
    data_range = i:i+2999;
    temp_vector = [sensor1(data_range); sensor2(data_range); sensor3(data_range); sensor4(data_range); sensor5(data_range)];
    
    % 将结果行向量添加到结果向量
    a = [a; temp_vector(:)'];
end
 disp('矩阵a中的每一行分别是 actionA1, actionA2, AactionA3, ... ');
 disp('矩阵a中的每3000列为一个传感器采集到的100个动作A，共五个传感器共15000列');


% 将结果保存在变量 a1, a2, a3, ... 中
% num_vectors = size(a, 1) / 15000;
% for i = 1:num_vectors
%     var_name = sprintf('a%d', i);
%     eval([var_name ' = a((i-1)*15000+1:i*15000, :)']);
% end
% 
% disp('数据已按要求提取并保存在变量 a1, a2, a3, ... 中。');




