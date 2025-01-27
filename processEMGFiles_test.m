clc;
clear
txtFilePaths = {
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/thumb/BlueBCI-2023-12-24-16-10-51/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/index finger/BlueBCI-2023-12-24-16-56-00/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/middle finger/BlueBCI-2023-12-24-17-14-19/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/ring_little/BlueBCI-2023-12-24-17-37-57/A9.txt'
};

[IN_abs, targets] = processEMGFiles(txtFilePaths);