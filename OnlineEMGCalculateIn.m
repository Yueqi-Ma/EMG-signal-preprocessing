function InA = OnlineEMGCalculateIn(interfaceAddress, interfacePort, bufferSize)
    % 全局变量
    n = 15; % 一次读入的点数，1个点33个字节

    global x;
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
    x = 0;
    powerSpectrum = [];
    


    % TCPIP连接设置
    interfaceObject = tcpip(interfaceAddress, interfacePort, 'NetworkRole', 'client');
    interfaceObject.InputBuffersize = 33 * n;
    interfaceObject.RemoteHost = interfaceAddress;
    bytesToRead = 33 * n;



    % 初始化PSD计算相关变量
    bufferCount = 0; %缓存计数器
    % 初始化结果矩阵
    InA = [];
    % 初始化结果向量
    a = [];
    % 初始化分割后的信号数据
    segmented_data = [];
    fs = 1000;
    % 定义每个循环的保留时间和去除时间
    action = 3 * fs;  % 三秒（3000行）
    rest = 2 * fs;  % 两秒（2000行）
    
    fopen(interfaceObject);

    pause(2);
    fprintf(interfaceObject, 'b');

    while isvalid(interfaceObject)
        % 检查是否有足够的数据读取
        if interfaceObject.BytesAvailable >= bytesToRead
            data_recv = fread(interfaceObject, bytesToRead);
            data_recv1 = reshape(data_recv, [33, n])';

            % 将接收到的数据转换为信号向量
            data = double(data_recv1(:, 2:33));
            % 去除指定的列
            columns_to_remove = [1, 5, 7, 8, 10, 11, 12];
            data(:, columns_to_remove) = [];

            % 更新全局变量x
            x = [x; data(:)];

            % 更新缓存计数器
            bufferCount = bufferCount + size(data, 1);

            % 如果缓存已满，则计算功率谱密度并绘制
            if bufferCount >= bufferSize
  
            % 获取数据的总行数
            total_rows = size(data, 1);

            % 进行循环分割
            for i = 1:rest+action:total_rows
                if i + rest+action - 1 <= total_rows
                 % 保留指定时间的数据
                    segmented_data = [segmented_data; data(i:i+action-1, :)];
                end
            end

             % 将分割后的数据保存到不同的变量中
                sensor1 = segmented_data(:, 1);    sensor2 = segmented_data(:, 2);
                sensor3 = segmented_data(:, 3);    sensor4 = segmented_data(:, 4);
                sensor5 = segmented_data(:, 5);



            % 提取数据并组成行向量
            for i = 1:3000:size(sensor1, 1)
                % 提取每个传感器的数据
                data_range = i:i+2999;
                temp_vector = [sensor1(data_range); sensor2(data_range); sensor3(data_range); sensor4(data_range); sensor5(data_range)];

                % 将结果行向量添加到结果向量
                a = [a; temp_vector(:)'];
            end

            % 计算每行传感器数据的FFT变换并保存结果
            num_rows = size(a, 1);
            num_fft_points = 1500;  % FFT变换后取正值的数据点数量

            for i = 1:num_rows
                % 提取每行的传感器数据
                row_data = a(i, :);

                % 初始化存储FFT变换结果的临时向量
                temp_vector = zeros(1, 5*num_fft_points);

                for j = 1:5
                  % 提取传感器数据的一组（3000个数据点）
                  sensor_data = row_data((j-1)*3000+1:j*3000);

                  % 对传感器数据进行FFT变换
                  transformed_data = fft(sensor_data);

                   % 取FFT变换结果的正值部分
                   positive_data = transformed_data(1:num_fft_points);

                    % 将正值部分保存在临时向量的相应位置
                    temp_vector((j-1)*num_fft_points+1:j*num_fft_points) = positive_data;
                end

             % 将临时向量的数据追加到结果矩阵中
               InA = [InA; temp_vector];
               InA= abs(InA);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end

                % 清空缓存计数器
                bufferCount = 0;

            end
        end
    end


    fclose(interfaceObject);
    delete(interfaceObject);

    %In=InA;
end
function localCloseFigure(~, ~, interfaceObject)
    fclose(interfaceObject);
    delete(interfaceObject);
    closereq;
end



%%

%interfaceAddress：TCP/IP接口地址
%interfacePort：TCP/IP接口端口
%bytesToRead：读取的字节数
%bufferSize：缓存大小

