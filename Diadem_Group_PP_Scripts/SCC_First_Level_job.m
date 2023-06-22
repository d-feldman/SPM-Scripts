%-----------------------------------------------------------------------
% Job saved on 22-Jun-2023 10:49:18 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
addpath /erato/mnemosyne/Software/SPM/spm12_r7219/

spm 'fmri'

cd /thalia/data/MickeyLab/DDEP22/FirstLevel/ 

subjectsList = readcell("/thalia/data/MickeyLab/DDEP22/Scripts/PreProcessing/Participants_List.txt");


for i = 1:height(subjectsList)

    % designate current subject to use, converting to string 
    currentSubject = string(subjectsList(i,1));

matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'FirstLevel1';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {cellstr(fullfile('/thalia/data/MickeyLab/DDEP22/ImagingData/SubjectsDerived/group_model/',currentSubject,'/func/SCC/run_01/swardc_ds_run_01.nii'))};
matlabbatch{2}.spm.stats.fmri_spec.dir = cellstr(fullfile('/thalia/data/MickeyLab/DDEP22/FirstLevel/',currentSubject,'/'));
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{2}.spm.stats.fmri_spec.sess.scans(1) = cfg_dep('Named File Selector: FirstLevel1(1) - Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'Off';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = [0
                                                         120
                                                         240
                                                         360
                                                         480];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = 60;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'On';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = [60
                                                         180
                                                         300
                                                         420
                                                         540];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = 60;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).orth = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{2}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.multi_reg = {''};
matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
matlabbatch{2}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'Off>On';
matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'Off<On';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{4}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{4}.spm.stats.con.delete = 0;

spm_jobman('run', matlabbatch);

end