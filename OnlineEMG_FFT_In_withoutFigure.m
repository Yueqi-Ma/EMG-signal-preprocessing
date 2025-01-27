%%
clear;clc;close all;
warning('off');
%% 全局变量
n = 15; % 一次读入的点数，1个点33个字节

global x;
global xT;


for i = 1:9
    eval(['global',' ch',num2str(i),';'])
    eval(['global',' sp',num2str(i),';'])
    eval(['ch',num2str(i) '= 0;']);
end

global step;

step = n; % 坐标轴补偿，应该和读入字节数相同

t = 0;
m = 0;
x = [];

%%
% % 读取图片
% image0 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\horse.jpg');
% image1 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image2 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image3 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image4 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image5 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image6 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image7 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image8 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image9 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');
% image10 = imread('D:\OneDrive - Macau University of Science and Technology\Desktop\MUST_year4A\FYP\EMG\processEMG\bci.png');


%% TCPIP连接设置
interfaceObject = tcpip('127.0.0.1', 12349, 'NetworkRole', 'client');
interfaceObject.InputBuffersize = 33 * n;
interfaceObject.RemoteHost = '127.0.0.1';
bytesToRead = 33 * n;

% 设置窗口
figureHandle = figure('NumberTitle', 'off',...
    'Name', 'Your Movements',...
    'Color', [1 1 1],...
    'position', [1 1 1536 864/3],...
    'CloseRequestFcn', {@localCloseFigure, interfaceObject});

% 设置axis
axesHandle = axes('Parent', figureHandle,...
    'YGrid', 'on',...
    'YColor', [1 1 1],...
    'XGrid', 'on',...
    'XColor', [0 0 0],...
    'Color', [0 0 0]);
xlabel(axesHandle, '时间');
ylabel(axesHandle, 'TBR');

%% 初始化绘图
plotHandle = plot(0, '-', 'LineWidth', 1, 'color', [0 0 1]);
grid minor

% 定义当输入缓冲区中达到所需字节数时要执行的回调函数
interfaceObject.BytesAvailableFcn = {@read, plotHandle, bytesToRead};
interfaceObject.BytesAvailableFcnMode = 'byte';
interfaceObject.BytesAvailableFcnCount = bytesToRead;
fopen(interfaceObject);

%pause(2);
fprintf(interfaceObject, 'b');

%% 
bufferSize = 3000;% 缓存大小
bufferCount = 0;%缓存计数器

fft_taltal = []; 


while isvalid(interfaceObject)
    % 检查是否有足够的数据读取
    if interfaceObject.BytesAvailable >= bytesToRead   
        data_recv = fread(interfaceObject,bytesToRead);
        data_recv1=reshape(data_recv,[33,bytesToRead/33]);
        data_recv2=data_recv1;
        road=data_recv1([3:3:27],:);
        data_recv2([3+0:3:27+0],:)=data_recv2([3:3:27],:)*2^16;
        data_recv2([3+1:3:27+1],:)=data_recv2([3+1:3:27+1],:)*2^8;
        data_recv2([3+2:3:27+2],:)=data_recv2([3+2:3:27+2],:)*2^0;
        
        % 通道
        data_channel=ones(9,bytesToRead/33);
        for i=1:9
            data_channel(i,:)=sum(data_recv2(3*i:3*i+2,:),1);
        end
        data=data_channel;
        dataT=data';
        % 更新全局变量x
        x = [x data];
        xT=x';
        % 更新缓存计数器
        bufferCount = bufferCount + size(data, 2);
        
        % 如果缓存已满，则计算功率谱密度并绘制
            if bufferCount >= bufferSize
               if bufferSize==3000
                %将缓存中的各个通道进行区分
                    CH1 = xT(end-bufferSize+1:end, 1);   %fprintf('CH1:\n'); size(CH1)
                    CH2 = xT(end-bufferSize+1:end, 2);
                    CH3 = xT(end-bufferSize+1:end, 3);
                    CH5 = xT(end-bufferSize+1:end, 5);
                    CH8 = xT(end-bufferSize+1:end, 8);
               
               elseif bufferSize>3000
                    CH1 = xT(end-(bufferSize-3000)*0.5-3000+1:end-(bufferSize-3000)*0.5, 1);  
                    CH2 = xT(end-(bufferSize-3000)*0.5-3000+1:end-(bufferSize-3000)*0.5, 2);
                    CH3 = xT(end-(bufferSize-3000)*0.5-3000+1:end-(bufferSize-3000)*0.5, 3);
                    CH5 = xT(end-(bufferSize-3000)*0.5-3000+1:end-(bufferSize-3000)*0.5, 5);
                    CH8 = xT(end-(bufferSize-3000)*0.5-3000+1:end-(bufferSize-3000)*0.5, 8);
                    
               else
                   fprintf('Buffer size cannot be less than 3000!!!!!!!!!!!')
               end
                               
                % 计算当前缓存中数据的FFT                    
                % 对每个通道进行FFT变换
                CH1_fft = fft(CH1);
                CH2_fft = fft(CH2);
                CH3_fft = fft(CH3);
                CH5_fft = fft(CH5);
                CH8_fft = fft(CH8);
                
                CH1_fft_positive = abs(CH1_fft(1:length(CH1_fft)/2));
                %fprintf('每个通道FFT变换后取正值的Size{CH_fft_positive}:\n'); 
                %size(CH1_fft_positive)
                CH2_fft_positive = abs(CH2_fft(1:length(CH2_fft)/2));
                CH3_fft_positive = abs(CH3_fft(1:length(CH3_fft)/2));
                %CH4_fft_positive = abs(CH4_fft(1:length(CH4_fft)/2));
                CH5_fft_positive = abs(CH5_fft(1:length(CH5_fft)/2));
                %CH6_fft_positive = abs(CH6_fft(1:length(CH6_fft)/2));
                %CH7_fft_positive = abs(CH7_fft(1:length(CH7_fft)/2));
                CH8_fft_positive = abs(CH8_fft(1:length(CH8_fft)/2));
                %CH9_fft_positive = abs(CH9_fft(1:length(CH9_fft)/2));
                
%%
                %fft_result是非常重要的变量，是输入到NN模型中的变量！！！！！！！！！！！！！
                %fft_result = [CH1_fft_positive CH2_fft_positive CH3_fft_positive CH4_fft_positive CH5_fft_positive CH6_fft_positive CH7_fft_positive CH8_fft_positive CH9_fft_positive];
                fft_result = [CH1_fft_positive' CH2_fft_positive' CH3_fft_positive' CH5_fft_positive'  CH8_fft_positive' ];%%%%%这个是每个buffer整理好的输入到ANN模型中的
                %fprintf('输入到NN模型的Size{fft_result}:\n'); 
                %size(fft_result)
                
                fft_taltal = [fft_taltal fft_result];
               % fprintf('fft_taltal:\n'); 
               % size(fft_taltal)
 %%           这个NN模型的输入必须是7500列    
                [Yd, Xf, Af] = myNeuralNetworkFunction10classes(fft_result, [], []);
                %fprintf('NN分类结果是是:\n'); 
                %disp([Yd]);
                Y = round(Yd);  
                %fprintf('The movement codes are:\n');
                %disp([Y]);
                ID = zeros(size(Y, 1), 1);  % 创建与 Y 行数相同的列向量 ID
                rowVector = Y(1, :);  % 获取 Y 的第 1 行行向量
                columnIndex = find(rowVector == 1);  % 查找元素为 1 的列索引
    
                 if isempty(columnIndex)|| (size(columnIndex,2)>1)
                    ID= 0;
                 else
                    ID = columnIndex;  % 将列索引赋值给 ID 的对应位置
                 end
                fprintf('The movement Number is:%d \n',ID); 
                datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')

                switch ID
                    case 1
                        fprintf('Thumb Flexion/Four Gesture!\n');
                        %imshow(image1)
                    case 2
                        fprintf('Index Finger Flexion\n');
                        %imshow(image2)
                    case 3
                        fprintf('Middle Finger Flexion\n');
                        %imshow(image3)
                    case 4
                        fprintf('Ring Finger & Little Finger Flexion\n');
                        %imshow(image4)
                    case 5
                        fprintf('Index Finger & Middle Finger Flexion，666！！！\n');
                        %imshow(image5)
                    case 6
                        fprintf('OK Gesture \n');
                        %imshow(image6)
                    case 7
                        fprintf(' Finger Gun! BiuBiuBiu!!!\n Eight Gesture\n');
                        %imshow(image7)
                    case 8
                        fprintf('V-Sign! VICTORY！！！\n');
                        %imshow(image8)
                    case 9
                        fprintf('Lateral Grip\n');
                        %imshow(image9)
                    case 10
                        fprintf('Using Spoon\n');
                       %imshow(image10)
                    otherwise
                        fprintf(' Invalid Movement!\n Repeat your movement again! \n');
                        %imshow(image0)
                end
%%
            % 清空缓存计数器
            bufferCount = 0;
            end
         %else
             %   fprintf('bufferSize 不匹配通道数:\n');
            %end
    end
end

%% 关闭TCP/IP连接
fclose(interfaceObject);
delete(interfaceObject);
clear interfaceObject;

%% 关闭窗口的回调函数
function localCloseFigure(~, ~, interfaceObject)
    fclose(interfaceObject);
    delete(interfaceObject);
    clear interfaceObject;
    delete(gcf);
    %closereq;
end


%%
% %% 读取数据的回调函数
 function read(interfaceObject, ~, plotHandle, bytesToRead)
%     global x;
%     global powerSpectrum;
%     
%     % 读取数据
%     if interfaceObject.BytesAvailable >= bytesToRead
%         data_recv = fread(interfaceObject, bytesToRead);
%         data_recv1 = reshape(data_recv, [33, n])';
%         
%         % 将接收到的数据转换为信号向量
%         data = double(data_recv1(:, 2:33));
%         
%         % 更新全局变量x
%         x = [x; data(:)];
%         xT=x';
%         % 更新缓存计数器
%         bufferCount = bufferCount + size(data, 1);
%         %size(data)
%         % 如果缓存已满，则计算功率谱密度并绘制
%         if bufferCount >= bufferSize
%             % 计算当前缓存中数据的FFT
%             fft_result = fft(x(end-bufferCount+1:end));
%             fft_taltal = [fft_taltal; fft_result];
%            
%             
%             % 清空缓存计数器
%             bufferCount = 0;
%             
%             % 绘制动态图
%             %t = t + 1;
%            % plot(axesHandle, 1:t, tbr, '-', 'LineWidth', 1, 'color', [0 0 1]);
%             %xlim(axesHandle, [1 t]);
%              %xlabel(axesHandle, '时间');
%             %ylim(axesHandle, [min(tbr) max(tbr)]);
%             %ylabel(axesHandle, 'TBR');
%             
%             %drawnow;
%         end
%     end
 end