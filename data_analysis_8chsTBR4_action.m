%%
clear;clc;close all;
warning('off');


%% 全局变量
n = 15; % �?次读入的点数�?1个点33个字�?

global x;
%global xT;
global powerSpectrum;

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
powerSpectrum = [];

%% TCPIP连接设置
interfaceObject = tcpip('127.0.0.1', 12349, 'NetworkRole', 'client');
interfaceObject.InputBuffersize = 33 * n;
interfaceObject.RemoteHost = '127.0.0.1';
bytesToRead = 33 * n;

% 设置窗口
figureHandle = figure('NumberTitle', 'off',...
    'Name', 'TBR动�?�图',...
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

%% 初始化绘�?
plotHandle = plot(0, '-', 'LineWidth', 1, 'color', [0 0 1]);
grid minor

% 定义当输入缓冲区中达到所�?字节数时要执行的回调函数
interfaceObject.BytesAvailableFcn = {@read, plotHandle, bytesToRead};
interfaceObject.BytesAvailableFcnMode = 'byte';
interfaceObject.BytesAvailableFcnCount = bytesToRead;
fopen(interfaceObject);

%pause(2);
fprintf(interfaceObject, 'b');

%% 初始化PSD计算相关变量
bufferSize = 100;% 缓存大小，用于计算功率谱密度
bufferCount = 0;%缓存计数�?
thetaFreqRange = [4 8]; % θ波频率范�?
betaFreqRange = [12 30]; % β波频率范�?
thetaPSD = []; % 存储θ波频率段的PSD
betaPSD = []; % 存储β波频率段的PSD
tbr = []; % 存储TBR�?
tbrlow=0;
tbrhigh=0;
detercnt=0;


while isvalid(interfaceObject)
    % �?查是否有足够的数据读�?
    if interfaceObject.BytesAvailable >= bytesToRead
%         data_recv = fread(interfaceObject, bytesToRead);
%         data_recv1 = reshape(data_recv, [33, n])';
%         
%         % 将接收到的数据转换为信号向量
%         data = double(data_recv1(:, 2:33));
%       
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
        
        % 更新全局变量x
        x = [x data];
        xT=x';
        % 更新缓存计数�?
        bufferCount = bufferCount + size(data, 1);
        
        % 
        if bufferCount >= bufferSize
            
             CH1 = xT(end-bufferSize+1:end, 1);   %fprintf('CH1:\n'); size(CH1)
             CH2 = xT(end-bufferSize+1:end, 2);
             CH3 = xT(end-bufferSize+1:end, 3);
             CH4 = xT(end-bufferSize+1:end, 4);
             CH5 = xT(end-bufferSize+1:end, 5);
             CH6 = xT(end-bufferSize+1:end, 6);
             CH7 = xT(end-bufferSize+1:end, 7);
             CH8 = xT(end-bufferSize+1:end, 8);
            
            ch=[CH1 CH2 CH3 CH4 CH5 CH6 CH7 CH8 ];
            %fprintf('CH  x  :\n'); size(ch)
             
             
            % 计算当前缓存中数据的功率谱密度（PSD�?
            %[pxx, f] = pwelch(x(end-bufferSize+1:end), [], [], [], 1000);
            [pxx1, f1] = pwelch(ch(end-bufferSize+1:end,1), [], [], [], 1000);
            [pxx2, f2] = pwelch(ch(end-bufferSize+1:end,2), [], [], [], 1000);
            [pxx3, f3] = pwelch(ch(end-bufferSize+1:end,3), [], [], [], 1000);
            [pxx4, f4] = pwelch(ch(end-bufferSize+1:end,4), [], [], [], 1000);
            [pxx5, f5] = pwelch(ch(end-bufferSize+1:end,5), [], [], [], 1000);
            [pxx6, f6] = pwelch(ch(end-bufferSize+1:end,6), [], [], [], 1000);
            [pxx7, f7] = pwelch(ch(end-bufferSize+1:end,7), [], [], [], 1000);
            [pxx8, f8] = pwelch(ch(end-bufferSize+1:end,8), [], [], [], 1000);
            
            
            
            
            
%%          
%             thetaIdx = find(f >= thetaFreqRange(1) & f <= thetaFreqRange(2));
%             thetaAvgPSD = mean(pxx(thetaIdx));
%             thetaPSD = [thetaPSD; thetaAvgPSD];

             % 计算θ波频率段的平均PSD
            thetaIdx1 = find(f1 >= thetaFreqRange(1) & f1 <= thetaFreqRange(2));
            thetaAvgPSD1 = mean(pxx1(thetaIdx1));
            
            thetaIdx2 = find(f2 >= thetaFreqRange(1) & f2 <= thetaFreqRange(2));
            thetaAvgPSD2 = mean(pxx2(thetaIdx2));
            
            thetaIdx3 = find(f3 >= thetaFreqRange(1) & f3 <= thetaFreqRange(2));
            thetaAvgPSD3 = mean(pxx3(thetaIdx3));
            
            thetaIdx4 = find(f4 >= thetaFreqRange(1) & f4 <= thetaFreqRange(2));
            thetaAvgPSD4 = mean(pxx4(thetaIdx4));
            
            thetaIdx5 = find(f5 >= thetaFreqRange(1) & f5 <= thetaFreqRange(2));
            thetaAvgPSD5 = mean(pxx5(thetaIdx5));
            
            thetaIdx6 = find(f6 >= thetaFreqRange(1) & f6 <= thetaFreqRange(2));
            thetaAvgPSD6 = mean(pxx6(thetaIdx6));
            
            thetaIdx7 = find(f7 >= thetaFreqRange(1) & f7 <= thetaFreqRange(2));
            thetaAvgPSD7 = mean(pxx7(thetaIdx7));
            
            thetaIdx8 = find(f8 >= thetaFreqRange(1) & f8 <= thetaFreqRange(2));
            thetaAvgPSD8 = mean(pxx8(thetaIdx8));
            
            
%             thetaPSD=[thetaAvgPSD1 thetaAvgPSD2 thetaAvgPSD3 thetaAvgPSD4 thetaAvgPSD5 thetaAvgPSD6 thetaAvgPSD7 thetaAvgPSD8 ]
%             
%             thetaPSD = mean([thetaPSD ]);
            
%%            
            betaIdx1 = find(f1 >= betaFreqRange(1) & f1 <= betaFreqRange(2));
            betaAvgPSD1 = mean(pxx1(betaIdx1));
            
            betaIdx2 = find(f2 >= betaFreqRange(1) & f2 <= betaFreqRange(2));
            betaAvgPSD2 = mean(pxx2(betaIdx2));
            
            betaIdx3 = find(f3 >= betaFreqRange(1) & f3 <= betaFreqRange(2));
            betaAvgPSD3 = mean(pxx3(betaIdx3));
            
            betaIdx4 = find(f4 >= betaFreqRange(1) & f4 <= betaFreqRange(2));
            betaAvgPSD4 = mean(pxx4(betaIdx4));
            
            betaIdx5 = find(f5 >= betaFreqRange(1) & f5 <= betaFreqRange(2));
            betaAvgPSD5 = mean(pxx5(betaIdx5));
            
            betaIdx6 = find(f6 >= betaFreqRange(1) & f6 <= betaFreqRange(2));
            betaAvgPSD6 = mean(pxx6(betaIdx6));
            
            betaIdx7 = find(f7 >= betaFreqRange(1) & f7 <= betaFreqRange(2));
            betaAvgPSD7 = mean(pxx7(betaIdx7));
            
            
            betaIdx8 = find(f8 >= betaFreqRange(1) & f8 <= betaFreqRange(2));
            betaAvgPSD8 = mean(pxx8(betaIdx8));
            
%             betaPSD=[betaAvgPSD1 betaAvgPSD2 betaAvgPSD3 betaAvgPSD4 betaAvgPSD5 betaAvgPSD6 betaAvgPSD7 betaAvgPSD8 ]
%             
%             betaPSD = mean([betaPSD ]);

            
  %%         
            
            tbrValue1 = thetaAvgPSD1 / betaAvgPSD1;
            tbrValue2 = thetaAvgPSD2 / betaAvgPSD2;
            tbrValue3 = thetaAvgPSD3 / betaAvgPSD3;
            tbrValue4 = thetaAvgPSD4 / betaAvgPSD4;
            tbrValue5 = thetaAvgPSD5 / betaAvgPSD5;
            tbrValue6 = thetaAvgPSD6 / betaAvgPSD6;
            tbrValue7 = thetaAvgPSD7 / betaAvgPSD7;
            tbrValue8 = thetaAvgPSD8 / betaAvgPSD8;
            tbrValue = mean([tbrValue1 tbrValue2 tbrValue3 tbrValue4 tbrValue5 tbrValue6 tbrValue7 tbrValue8]);
            
            
            
            
            detercnt=detercnt+1;
            %detercnt
            if detercnt<30
                if tbrValue<5
                    tbrlow=tbrlow+1;
                    tbrlow
                else
                    tbrhigh=tbrhigh+1;
                    tbrhigh
                end
               
            else
                detercnt=0;
                problow=tbrlow/(tbrlow+tbrhigh)
                tbrlow=0;
                tbrhigh=0;
                if problow>0.7
                   fprintf('70%的TBR低于阈�??:\n');
                datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')

                else
                    fprintf('大了大了大了大了大了大了大了大了大了大了:\n');
                datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
 
                end
            end
            tbr = [tbr; tbrValue];
            
            % 清空缓存计数�?
            bufferCount = 0;
            
            % 绘制动�?�图
            t = t + 1;
            plot(axesHandle, 1:t, tbr, '-', 'LineWidth', 1, 'color', [0 0 1]);
             %xlim(axesHandle, [1 t]);
             xlabel(axesHandle, '时间');
            %ylim(axesHandle, [min(tbr) max(tbr)]);
            ylabel(axesHandle, 'TBR');
            
            drawnow;
        end
    end
end

%% 关闭TCP/IP连接
fclose(interfaceObject);
delete(interfaceObject);
clear interfaceObject;

%% 关闭窗口的回调函�?
function localCloseFigure(~, ~, interfaceObject)
    fclose(interfaceObject);
    delete(interfaceObject);
    clear interfaceObject;
    delete(gcf);
    %closereq;
end
