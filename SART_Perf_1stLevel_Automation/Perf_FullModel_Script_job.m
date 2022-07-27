%-----------------------------------------------------------v------------
% Job saved on 26-Jul-2022 10:07:42 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%For Loop Initiation%%
subjects = ('3516_02'); %fill in subject number list%

scans = (1:490); %scan number for swtr scan%


for subjects=subjects

    matlabbatch{1}.spm.stats.fmri_spec.dir = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/' subjects '/UnresolvedSubDs}'};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    for scans=scans
    
           matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {
                                                    '/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/' subjects '/func/Unresolved/run_01/swr12tr_dc_run_01.nii,' char(scans)
                                                    };
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Rejections';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_01_reject.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Targets';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_01_target.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'Commissions';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_01_comm.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'Omissions';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_01_omm.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {'/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/' subjects '/func/Unresolved/run_01/rp_tr_dc_run_01.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

    for scans=scans
        matlabbatch{1}.spm.stats.fmri_spec.s 
ess(2).scans = {
                                                    '/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/' subjects '/func/Unresolved/run_02/swr12tr_dc_run_02.nii,' char(scans) 
                                                             };
    end                                                     
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'Rejections';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_02_reject.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'Targets';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_02_target.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'Commissions';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_02_comm.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = 'Omissions';
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_02_omm.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {'/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/' subjects' '/func/Unresolved/run_02/rp_tr_dc_run_02.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;

    for scans=scans
    
        matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {
                                                    '/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/' subjects '/func/Unresolved/run_01/swr12tr_dc_run_03.nii,' char(scans)
                                                    };
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).name = 'Rejections';
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_03_reject.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = 'Targets';
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_03_target.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).name = 'Commissions';
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_03_comm.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).name = 'Omissions';
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).onset = {'/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/onset_times/' subjects '/run_03_omm.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).orth = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {'/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/' subjects '/func/Unresolved/run_03/rp_tr_dc_run_03.txt'};
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;


    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'/thalia/data/MEND2/RUME19/Scripts/Analysis/Tasks/Rumination/newSegsymmetric_2mm_EPI_MASK_NOEYES.nii'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'RejectionsOnly';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Targets';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Commissions';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Omissions';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Rejections-Commissions';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Commissions-Rejections';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Targets-Omissions';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [0 0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Omissions-Targets';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 -0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Targets-Commissions';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [0 0.33 -0.33 0 0 0 0 0 0 0 0 0.33 -0.33 0 0 0 0 0 0 0 0 0.33 -0.33 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Commissions-Targets';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [0 -0.33 0.33 0 0 0 0 0 0 0 0 -0.33 0.33 0 0 0 0 0 0 0 0 -0.33 0.33 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Rejections-Omissions';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0.33 0 0 -0.33 0 0 0 0 0 0 0.33 0 0 -0.33 0 0 0 0 0 0 0.33 0 0 -0.33 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Omissions-Rejections';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [-0.33 0 0 0.33 0 0 0 0 0 0 -0.33 0 0 0.33 0 0 0 0 0 0 -0.33 0 0 0.33 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    spm_jobman('run',matlabbatch);

end
