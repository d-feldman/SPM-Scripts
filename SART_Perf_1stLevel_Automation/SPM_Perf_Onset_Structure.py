##Script to convert onset times excel into usable organization structure and file type for SPM12 Analysis##

import os
import pandas as pd
import numpy as np

## create subject list variable##
subject_list = ['3516', '3518', '3521', '3524', '3525',
                '3538','3542','3568','3569','3593','4518','4520',
                '4548','4552','4554']

## root path
root_path = '/Users/danielfeldman/Desktop/onset_times/'
os.makedirs(root_path, exist_ok=True)


## create sub folder structure based on subject list##

for sub in subject_list:
    ofolder = root_path + "/" + sub 
    os.makedirs(ofolder, exist_ok=True)


## function to pull from columns and make .txt list ##
onset_file = pd.ExcelFile('/Users/danielfeldman/Desktop/T2_Perf_Onset.xlsx')


condition = ['run_01_reject', 'run_01_target', 'run_01_comm', 'run_01_omm',
            'run_02_reject','run_02_target', 'run_02_comm', 'run_02_omm',
            'run_03_reject','run_03_target', 'run_03_comm', 'run_03_omm']

for sub in subject_list:
    sub1 = pd.read_excel(onset_file, sub, na_filter = False)

    run_01_reject = sub1.iloc[0:226, 1:2]

    run_01_target = sub1.iloc[0:226, 2:3]

    run_01_comm = sub1.iloc[0:226, 3:4]

    run_01_omm = sub1.iloc[0:226, 4:5]

    run_02_reject = sub1.iloc[226:451, 1:2]

    run_02_target = sub1.iloc[226:451, 2:3]

    run_02_comm = sub1.iloc[226:451, 3:4]

    run_02_omm = sub1.iloc[226:451, 4:5]

    run_03_reject = sub1.iloc[451:676, 1:2]

    run_03_target = sub1.iloc[451:676, 2:3]

    run_03_comm = sub1.iloc[451:676, 3:4]

    run_03_omm = sub1.iloc[451:676, 4:5]

    for cond in condition:
         with open('/Users/danielfeldman/Desktop/onset_times/' + sub + '/' + cond +'.txt', 'w' ) as f:
	           f.write((locals()[cond]).to_string())

## function to organize .txt list into respective folder ##

