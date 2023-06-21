%-----------------------------------------------------------------------
% Job saved on 21-Jun-2023 13:49:33 by cfg_util (rev $Rev: 6942 $)
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

matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'run1File';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {cellstr(fullfile('/thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/',currentSubject,'/func/SCC/run_01/wardc_ds_run_01.nii'))};
matlabbatch{2}.spm.spatial.smooth.data(1) = cfg_dep('Named File Selector: run1File(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{2}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{2}.spm.spatial.smooth.dtype = 0;
matlabbatch{2}.spm.spatial.smooth.im = 0;
matlabbatch{2}.spm.spatial.smooth.prefix = 's';

spm_jobman('run', matlabbatch);

end

exit