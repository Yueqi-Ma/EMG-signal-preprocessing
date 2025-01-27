clc;
clear
close all;
%%
interfaceAddress = '127.0.0.1';
%interfacePort = 12349;
interfacePort = 1234;
%bytesToRead = 1000;
bufferSize = 3000;
%%
In1 = OnlineEMGCalculateIn(interfaceAddress, interfacePort, bufferSize);

X = In1;
X=abs(X);
[Yd, Xf, Af] = myNeuralNetworkFunction(X, [], []);
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

