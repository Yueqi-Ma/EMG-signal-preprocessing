
clear; clc;
% 替换为实际的txt文件路径
txtFilePathA = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/thumb/BlueBCI-2023-12-24-16-10-51/A9.txt';
txtFilePathB = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/index finger/BlueBCI-2023-12-24-16-56-00/A9.txt';
txtFilePathC = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/middle finger/BlueBCI-2023-12-24-17-14-19/A9.txt';
txtFilePathD = 'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/ring_little/BlueBCI-2023-12-24-17-37-57/A9.txt';

InA = calculateIn(txtFilePathA);
InB = calculateIn(txtFilePathB);
InC = calculateIn(txtFilePathC);
InD = calculateIn(txtFilePathD);

IN1=[InA;InB;InC;InD];
IN1_abs = abs(IN1);

writematrix(IN1_abs, 'IN1_abs.txt', 'Delimiter', ';');
%writematrix(IN1, 'IN1.txt', 'Delimiter', ';');


rowsA = size(InA, 1);   
rowsB = size(InB, 1);  
rowsC = size(InC, 1);  
rowsD = size(InD, 1);  

targets = [
  repmat([1, 0, 0, 0], rowsA, 1);   % 前rowsA行是[1, 0, 0, 0]
  repmat([0, 1, 0, 0], rowsB, 1);   % rowsB[0, 1, 0, 0]
  repmat([0, 0, 1, 0], rowsC, 1);   % rowsC[0, 0, 1, 0]
  repmat([0, 0, 0, 1], rowsD, 1)    % rowsD[0, 0, 0, 1]
];

writematrix(targets, 'Targets.txt', 'Delimiter', ';');





