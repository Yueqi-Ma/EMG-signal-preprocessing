%%
clear;
clc;close all;
warning('off');

%%
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

%%
SCOM = serial('COM3');%���ô���
SCOM.InputBufferSize = 1024;
SCOM.OutputBufferSize = 1024;
SCOM.BaudRate = 115200;
SCOM.Parity = 'none';
SCOM.StopBits = 1;
SCOM.DataBits = 8;
SCOM.Timeout = 0.5;
SCOM.BytesAvailableFcnMode = 'byte';
SCOM.BytesAvailableFcn = @callback;
fopen(SCOM);%�򿪴���
fwrite(SCOM,'START');

%% 
% !start matlab -r "run('TBR4with2TCPIP.m');"
% !start matlab -r "run('EMGwithTCPIP.m');"

%% 
TBR=[];
TBRtemp2=[];
ID2=0;
detercnt=0;
tbrlow=0;
tbrhigh=0;
threshold=1.34;
%%
while true
    % 打开文件进行读取
    fileID2 = fopen('EMG_ID.txt', 'r');
    fileID1 = fopen('TBRtemp.txt', 'r');
    
    % 从文件中读取数据
    TBRtemp1 = fscanf(fileID1, '%f');
    
    EMG_ID_data = fscanf(fileID2, '%f');

    % 关闭文件
    fclose(fileID2);
    fclose(fileID1);
    
    
    %%
    if ~isempty(TBRtemp1) && ~isequal(TBRtemp1, TBRtemp2)
        
        %fprintf('读到�?组新的TBR\n');
        %datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
        %TBR=[TBR;TBRtemp1];
        TBRtemp2=TBRtemp1;
        
            detercnt=detercnt+1;
            %detercnt
            if detercnt<20
                if TBRtemp1<threshold       
                    tbrlow=tbrlow+1;
                    %tbrlow
                else
                    tbrhigh=tbrhigh+1;
                    %tbrhigh
                end
               
            else
                detercnt=0;
                problow=tbrlow/(tbrlow+tbrhigh);
                tbrlow=0;
                tbrhigh=0;
                if problow>0.7 %%TBR low, foucsing on 
                  
                  datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
                  fprintf('tbr Low\n');
                  fprintf('%d percent of TBRs are lower than the threhold??:\n',problow*100);
                  
                  
                  
                  
            
                  

                else
                    datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
                    fprintf('TBR higher than the threhold\n');
                end
            end

   end  
    
    
    %%
    
     if ~isempty(EMG_ID_data) && ~isequal(EMG_ID_data, ID2)
        
        ID2=EMG_ID_data;
        
              switch ID2
                    case 1
                        fprintf('Thumb Flexion/Four Gesture!\n');
                        fwrite(SCOM,'LF1000');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image1)
                        title('Thumb Flexion/Four Gesture!');
                    case 2
                        fprintf('Index Finger Flexion\n');
                        fwrite(SCOM,'LF0100');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image2)
                        title('Index Finger Flexion');
                        
                    case 3
                        fprintf('Middle Finger Flexion\n');
                        fwrite(SCOM,'LF0010');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image3)
                    case 4
                        fprintf('Ring Finger & Little Finger Flexion\n');
                        fwrite(SCOM,'LF0001');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image4)
                        close all
                    case 5
                        fprintf('Index Finger & Middle Finger Flexion�?666！！！\n');
                        fwrite(SCOM,'LF0110');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image5)
                    case 6
                        fprintf('OK Gesture \n');
                        fwrite(SCOM,'LF1100');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image6)
             
                    case 7
                        fprintf(' Finger Gun! BiuBiuBiu!!!\n Eight Gesture\n');
                        fwrite(SCOM,'LF0011');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image7)
                    case 8
                        fprintf('V-Sign! VICTORY！！！\n');
                        fwrite(SCOM,'LF1001');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image8)
                    case 9
                        fprintf('Lateral Grip\n');
                        fwrite(SCOM,'LF1011');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image9)
                    case 10
                        fprintf('Using Spoon\n');
                        fwrite(SCOM,'LF1110');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                       imshow(image10)
                    otherwise
                        fprintf(' Invalid Movement!\n Repeat your movement again! \n');
                        fwrite(SCOM,'LF1111');
                        pause(3);
                        fwrite(SCOM,'LE1111');
                        pause(3);
                        imshow(image0)
              end

    
        
        
        datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS')
        fprintf('This EMG ID is:%d\n',ID2);
        
     end
     
     
end




