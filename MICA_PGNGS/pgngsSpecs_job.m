%% From SPM manual: 43.7.6 Creating a 1st-level (fMRI) GLM
% Anna Jacobsen & Daniel Feldman
% 04/12/2023

%%
% import timing file (currently located on Anna's computer for testing - will move to thalia at some point)
timeFile = fullfile(ExpDir,'ImagingData','SubjectsDerived',strcat(currentSubject,'_01'),'func','PGNGS',strcat(currentSubject,'PGNGStimes.txt'));
times = table2array(readtable(timeFile));


% import categorization matrix (currently located on Anna's computer for testing - will move to thalia at some point)
labelFile = fullfile(ExpDir,'ImagingData','SubjectsDerived',strcat(currentSubject,'_01'),'func','PGNGS',strcat(currentSubject,'PGNGSdatalabels.txt'));
labels = table2array(readtable(labelFile));


% names for each condition
names = {'Targets';'Commissions';'Lures';'Omissions';'Missed Opportunities'};

%% Set up specifications for all sessions
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile('/thalia/data/MEND2/MICA20/FirstLevel',currentSubject));
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

%% The loop!
% loop through each session
for i = 1:sessions
    % don't really understand what spm_select is doing or what these variables mean but made them iterable
    % rest of the loop script runs correctly when this section is commented out, still need to define some variables for spm_select
    P = spm_select('ExtFPList',subjectDataDir{i},runFileWild,tempFrames);
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).scans = cell(size(P,1),1);
    for iP = 1:size(P,1)
        matlabbatch{1}.spm.stats.fmri_spec.sess(i).scans{iP} = strtrim((P(iP,:)));
    end
    % loop through categorization matrix
    % initialize variable reused in loops
    C = 0;
    for n = 1:length(names)
        % is there is data for a condition, create that condition
        if logical(labels(i,n)) == 1
            C = C + 1;
            if C > 0
            matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(C).name = names{n};
            % initialize variables reused in loop
            count = 0;
            onsets = {};
            % loop through data from timing file 
            for j = 1:height(times)
                % if data is from this session and is a number, add to onset array
                if times(j,1) == i && isnan(times(j,n+1)) == 0
                    count = count + 1;
                    onsets{count} =  times(j,n+1);
                end
            end
            onsets = cell2mat(onsets);
            % set onset times using onset array
            matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(C).onset = onsets;
            end
        % set other parameters, same for all sessions and conditions
        matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(C).duration = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(C).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(C).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond(C).orth = 1;
        end
    end
    % set other parameters, same for all sessions and conditions 
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi_reg = cellstr(fullfile('/thalia/data/MEND2/MICA20/ImagingData/SubjectsDerived',strcat(currentSubject,'_01'),strcat('func/PGNGS/run_0',string(i),'/rp_tr_dc_run_0',string(i),'.txt')));
    matlabbatch{1}.spm.stats.fmri_spec.sess(i).hpf = 128; 
end

%Estimate SPM.mat
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% Define first level contrasts
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Targets Only';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [0.166 0 0 0 0 0 0 0 0.166 0 0 0 0 0 0 0 0 0 0 0.166 0 0 0 0 0 0 0 0 0 0.166 0 0 0 0 0 0 0 0.166 0 0 0 0 0 0 0 0 0 0 0.166 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Rejections Only';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 0 0 0 0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0.25 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'TargetsMinusRejections';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0.166 0 0 0 0 0 0 0 0.166 -0.25 0 0 0 0 0 0 0 0 0 0.166 -0.25 0 0 0 0 0 0 0 0 0.166 0 0 0 0 0 0 0 0.166 -0.25 0 0 0 0 0 0 0 0 0 0.166 -0.25 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'RejectionsMinusTargets';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-0.166 0 0 0 0 0 0 0 -0.166 0.25 0 0 0 0 0 0 0 0 0 -0.166 0.25 0 0 0 0 0 0 0 0 -0.166 0 0 0 0 0 0 0 -0.166 0.25 0 0 0 0 0 0 0 0 0 -0.166 0.25 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'GoTargetsOnly';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'GoNoGoTargetsOnly';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'GoStopTargetsOnly';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'StopRejectionsMinusGoNoGoRejections';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'GoNoGoRejectionsMinusStopRejections';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.convec = [0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'StopTargetsMinusGoNoGoTargets';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.convec = [0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'GoNoGoTargetsMinusStopTargets';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.convec = [0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'StopRejectsOnly';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'NoGoRejectsOnly';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.convec = [0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
