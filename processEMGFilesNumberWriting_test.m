clc;
clear
txtFilePaths = {
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/2/BlueBCI-2024-01-23-16-25-16/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/3/BlueBCI-2024-01-23-16-47-38/A9.txt'
   };

[IN_abs, targets] = processEMGFiles(txtFilePaths);