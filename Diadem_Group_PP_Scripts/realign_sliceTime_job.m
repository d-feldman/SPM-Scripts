%-----------------------------------------------------------------------
% Job saved on 08-Jun-2023 08:55:58 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

addpath /erato/mnemosyne/Software/SPM/spm12_r7219/

spm 'fmri'

cd /thalia/data/MickeyLab/DDEP22/Scripts/PreProcessing/Group_PP_Scripts/ 

subjectsList = readcell("/thalia/data/MickeyLab/DDEP22/Scripts/PreProcessing/Participants_List.txt");


for i = 1:height(subjectsList)

    % designate current subject to use, converting to string 
    currentSubject = string(subjectsList(i,1));
    subj_file = strcat('/thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/', currentSubject, '/func/SCC/run_01/dc_ds_run_01.nii');

matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'run1File';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {cellstr(fullfile('/thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/',currentSubject,'/func/SCC/run_01/dc_ds_run_01.nii'))};
matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Named File Selector: run1File(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
matlabbatch{3}.spm.temporal.st.scans{1}(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{3}.spm.temporal.st.nslices = 52;
matlabbatch{3}.spm.temporal.st.tr = 2;
matlabbatch{3}.spm.temporal.st.ta = 1.97;
matlabbatch{3}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52];
matlabbatch{3}.spm.temporal.st.refslice = 10;
matlabbatch{3}.spm.temporal.st.prefix = 'a';

spm_jobman('run', matlabbatch);

end

exit
