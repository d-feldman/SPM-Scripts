%-----------------------------------------------------------------------
%Written By Daniel Feldman and Anna Jacobsen
%JUN22_2023
%Sustained Attention Response Task Event Related Performance 1st Level Models in SPM.
%-----------------------------------------------------------------------

addpath /erato/mnemosyne/Software/SPM/spm12_r7219/

spm 'fmri' 

subjectsList = readcell("/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/Participants_List.txt");

%%
for i = 1:height(subjectsList)

    %designate current subject to use, converting to string 
    currentSubject = string(subjectsList(i,1));
    currentSubject = strsplit(currentSubject, '_');
    currentSubject = string(currentSubject(1));
    
    %make parent folder
    %mkdir (fullfile('/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/',currentSubject,'/'))
   
    %make perf output folder
    %mkdir (fullfile('/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/',currentSubject,'/perf'))
    
    opts = spreadsheetImportOptions;
    opts.VariableNames = {'Run';'NoGo';'CorrectNoGo';'CorrectGo';'ErrorCommissions';'ErrorOmissions'};
    opts.Sheet = currentSubject;
    filename = 'PerformanceOnsetsTime2.xlsx';
    sheets = sheetnames(filename);
    
    % checking for tab in main spreadsheet
    if contains(sheets,currentSubject) == 0
        disp(strcat(currentSubject,' spreadsheet does not exist :('))
        continue
    else
        data = str2double(table2array(readtable(filename,opts,'ReadVariableNames',1)));
    end
    
    % checking for runs
    inds = find(diff(data(:,1)))+1;
    if length(inds) < 2
        disp(strcat(currentSubject,' does not have all 3 runs'))
        continue
    end
    
    % checking for viable data
    TIMES = {};
    use = {};
    % creating timing variables for each run
    % run 1
    N = 0;
    for k = 1:4
        if any((data(1:inds(1),k+2))) == 1
            N = N+1;
            use1{1,N} = k;
            for j = 1:inds(1)
                TIMES{1,k}{j,1} = data(j,k+2);
            end
        else
            disp(strcat(currentSubject,'column',string(k+2),' run 1 has insufficient data'))
        end
    end
    % run 2
   N=0;
   for k = 1:4 
        if any((data(inds(1):inds(2),k+2))) == 1
            N = N+1;
            use2{1,N} = k;
            for j=inds(1):inds(2)
                TIMES{2,k}{j-inds(1)+1,1} = data(j,k+2);
            end
        else
            disp(strcat(currentSubject,'column',string(k+2),'run 2 has insufficient data'))
        end        
    end
    % run 3
    N=0;
    for k = 1:4
        if any((data(inds(2):length(data),k+2))) == 1
            N=N+1;
            use3{1,N} = k;
            for j = inds(2):length(data)
                TIMES{3,k}{j-inds(2)+1,1} = data(j,k+2);
            end
        else
            disp(strcat(currentSubject,'column',string(k+2),'run 3 has insufficient data'))
        end
    end

    use = {use1;use2;use3};

 %%
%Define Dependent SART RUNS
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'SART_RUNS';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                     cellstr(fullfile('/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/',strcat(currentSubject,'_02'),'/func/Unresolved/run_01/swr12tr_dc_run_01.nii'))
                                                                     cellstr(fullfile('/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/',strcat(currentSubject,'_02'),'/func/Unresolved/run_02/swr12tr_dc_run_02.nii'))
                                                                     cellstr(fullfile('/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/',strcat(currentSubject,'_02'),'/func/Unresolved/run_03/swr12tr_dc_run_03.nii'))
                                                                     }';

%Define Roll Pitch Yaw movement regressors                                                                
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'SART_RPY';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.cfg_named_file.files = {
                                                                     cellstr(fullfile('/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/',strcat(currentSubject,'_02'),'/func/Unresolved/run_01/rp_tr_dc_run_01.txt'))
                                                                     cellstr(fullfile('/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/',strcat(currentSubject,'_02'),'/func/Unresolved/run_02/rp_tr_dc_run_02.txt'))
                                                                     cellstr(fullfile('/thalia/data/MEND2/RUME19/ImagingData/SubjectsDerived/',strcat(currentSubject,'_02'),'/func/Unresolved/run_03/rp_tr_dc_run_03.txt'))
                                                                     }';                                                              
%fmri Model Specification
% 3 trials of SART Task, each with timing for 4 conditions.
names = {'Targets';'Rejections';'Commissions';'Omissions'};

matlabbatch{3}.spm.stats.fmri_spec.dir = cellstr(fullfile('/thalia/data/MEND2/RUME19/FirstLevel/Unresolved_02/',strcat(currentSubject,'_02'),'/perf'));
matlabbatch{3}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{3}.spm.stats.fmri_spec.timing.RT = 0.8;
matlabbatch{3}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{3}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
for k = 1:3
    for j = 1:length(use{k})
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).scans(1) = cfg_dep(strcat('Named File Selector: SART_RUNS(',string(k),') - Files'), substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).cond(j).name = names{use{k}{j}};
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).cond(j).onset = cell2mat(TIMES{k,use{k}{j}});
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).cond(j).duration = 0;
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).cond(j).tmod = 0;
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).cond(j).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).cond(j).orth = 1;
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).multi = {''};
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).multi_reg(1) = cfg_dep(strcat('Named File Selector: SART_RPY(',string(k),') - Files'), substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
    matlabbatch{3}.spm.stats.fmri_spec.sess(k).hpf = 128;
    end
end
matlabbatch{3}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{3}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{3}.spm.stats.fmri_spec.volt = 1;
matlabbatch{3}.spm.stats.fmri_spec.global = 'None';
matlabbatch{3}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{3}.spm.stats.fmri_spec.mask = {'/thalia/data/MEND2/RUME19/Scripts/Analysis/Tasks/Rumination/newSegsymmetric_2mm_EPI_MASK_NOEYES.nii'};
matlabbatch{3}.spm.stats.fmri_spec.cvi = 'AR(1)';

%Dependent Model Estimation
matlabbatch{4}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{4}.spm.stats.fmri_est.method.Classical = 1;

%Create Contrasts
matlabbatch{5}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{5}.spm.stats.con.consess{1}.tcon.name = 'RejectionsOnly';
matlabbatch{5}.spm.stats.con.consess{1}.tcon.weights = [0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{2}.tcon.name = 'Targets';
matlabbatch{5}.spm.stats.con.consess{2}.tcon.weights = [0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{3}.tcon.name = 'Commissions';
matlabbatch{5}.spm.stats.con.consess{3}.tcon.weights = [0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{4}.tcon.name = 'Omissions';
matlabbatch{5}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0 0 0 0 0.33 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{5}.tcon.name = 'Rejections-Commissions';
matlabbatch{5}.spm.stats.con.consess{5}.tcon.weights = [0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{6}.tcon.name = 'Commissions-Rejections';
matlabbatch{5}.spm.stats.con.consess{6}.tcon.weights = [-0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{7}.tcon.name = 'Targets-Omissions';
matlabbatch{5}.spm.stats.con.consess{7}.tcon.weights = [0 0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0 0 0.33 0 -0.33 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{8}.tcon.name = 'Omissions-Targets';
matlabbatch{5}.spm.stats.con.consess{8}.tcon.weights = [0 -0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0 0 -0.33 0 0.33 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{9}.tcon.name = 'Targets-Commissions';
matlabbatch{5}.spm.stats.con.consess{9}.tcon.weights = [0 0.33 -0.33 0 0 0 0 0 0 0 0 0.33 -0.33 0 0 0 0 0 0 0 0 0.33 -0.33 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{10}.tcon.name = 'Commissions-Targets';
matlabbatch{5}.spm.stats.con.consess{10}.tcon.weights = [0 -0.33 0.33 0 0 0 0 0 0 0 0 -0.33 0.33 0 0 0 0 0 0 0 0 -0.33 0.33 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{11}.tcon.name = 'Rejections-Omissions';
matlabbatch{5}.spm.stats.con.consess{11}.tcon.weights = [0.33 0 0 -0.33 0 0 0 0 0 0 0.33 0 0 -0.33 0 0 0 0 0 0 0.33 0 0 -0.33 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.consess{12}.tcon.name = 'Omissions-Rejections';
matlabbatch{5}.spm.stats.con.consess{12}.tcon.weights = [-0.33 0 0 0.33 0 0 0 0 0 0 -0.33 0 0 0.33 0 0 0 0 0 0 -0.33 0 0 0.33 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{5}.spm.stats.con.delete = 0;


spm_jobman('run', matlabbatch);

end
