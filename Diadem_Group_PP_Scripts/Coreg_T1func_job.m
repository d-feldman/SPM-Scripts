%-----------------------------------------------------------------------
% Job saved on 21-Jun-2023 11:21:06 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
addpath /erato/mnemosyne/Software/SPM/spm12_r7219/

spm 'fmri'

cd /thalia/data/MickeyLab/DDEP22/Scripts/PreProcessing/Group_PP_Scripts/ 

subjectsList = readcell("/thalia/data/MickeyLab/DDEP22/Scripts/PreProcessing/Participants_List.txt");

for i = 1:height(subjectsList)
    
    currentSubject = string(subjectsList(i,1));

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = cellstr(fullfile('/thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/',currentSubject,'/func/SCC/run_01/meandc_ds_run_01.nii,1'));
matlabbatch{1}.spm.spatial.coreg.estwrite.source = cellstr(fullfile('/thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/',currentSubject,'/anat/norm.nii,1'));
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

spm_jobman('run',matlabbatch);

end

exit
