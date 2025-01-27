clc;
clear
txtFilePaths = {
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/thumb/BlueBCI-2023-12-24-16-10-51/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/index finger/BlueBCI-2023-12-24-16-56-00/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/middle finger/BlueBCI-2023-12-24-17-14-19/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_fingers/ring_little/BlueBCI-2023-12-24-17-37-57/A9.txt',
    
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/2/BlueBCI-2024-01-22-14-26-01/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/6/BlueBCI-2024-01-22-16-16-21/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/8/BlueBCI-2024-01-22-15-58-24/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/lateral grip/BlueBCI-2024-01-23-11-57-00/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/OK/BlueBCI-2024-01-22-14-02-13/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/EMG_movements/spoon/BlueBCI-2024-01-23-12-27-12/A9.txt',

    
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/1/BlueBCI-2024-01-23-15-29-44/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/2/BlueBCI-2024-01-23-16-25-16/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/handwritingnumber/3/BlueBCI-2024-01-23-16-47-38/A9.txt',
    'D:/OneDrive - Macau University of Science and Technology/Desktop/MUST_year4A/FYP/EMG/YS_train_data/5YS/A9.txt',
    
    
    
};

[IN_abs, targets] = processEMGFiles14(txtFilePaths);