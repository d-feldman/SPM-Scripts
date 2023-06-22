%% From SPM manual: 43.7.6 Creating a 1st-level (fMRI) GLM
% Anna Jacobsen & Daniel Feldman
% 04/12/2023

%%
% import timing file 
timeFile = fullfile(ExpDir,'ImagingData','SubjectsDerived',strcat(currentSubject,'_01'),'func','PGNGS',strcat(currentSubject,'PGNGStimes.txt'));
times = table2array(readtable(timeFile));


% import categorization matrix 
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
            num = 0;
            onsets = {};
            % loop through data from timing file 
            for j = 1:height(times)
                % if data is from this session and is a number, add to onset array
                if times(j,1) == i && isnan(times(j,n+1)) == 0
                    num = num + 1;
                    onsets{num} =  times(j,n+1);
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
    
    %Add explicit mask
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'/thalia/data/MEND2/MICA20/FirstLevel/PGNGS/MNI152_T1_2mm_brain_mask.nii,1'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
end

%Estimate SPM.mat
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%% Define first level contrasts
% session names (Go, No Go, Stop)
sessNames = {'G';'Ng';'S'};
% condition names (Hits, Commissions, Rejections, Omissions, Missed Opportunities
condNames = {'Ht';'Cm';'Rej';'Om';'MOpp'};
% Contrast names
contrastNames = {'Cm';
'Rej';
'G_Ht';
'GNg_Ht';
'S_Ht';
'GNg_Rej';
'S_Rej';
'GNg_Cm';
'S_Cm';
'Cm_min_Rej';
'Rej_min_Cm';
'Cm_min_Ht';
'Ht_min_Cm';
'Rej_min_Ht';
'Ht_min_Rej';
'GNg2T_Ht';
'GNg3T_Ht';
'S2T_Ht';
'S3T_Ht';
'GNg2T_Rej';
'GNg3T_Rej';
'S2T_Rej';
'S3T_Rej';
'GNg2T_Cm';
'GNg3T_Cm';
'S2T_Cm';
'S3T_Cm';
'MOpp';
'Om';
'G_Om';
'GNg_Om';
'S_Om';
'GNg2T_Om';
'GNg3T_Om';
'S2T_Om';
'S3T_Om';};

% initializing variables used in loop
allContrasts = {};
Z = zeros(1,6);
% loop through each contrast name
for c = 1:length(contrastNames)
    % split name at underscores
    name = split(contrastNames{c},'_');
    diff = 0;
    % if just one section within the name, assuming it corresponds to one
    % condition only for all sessions
    if length(name) == 1
        for i = 1:length(condNames)
            if contains(name{1},condNames{i}) == 1
                % saving the index of that condition 
                firstCond = i;
            end
        end
    % if two sections within the name, assuming it corresponds to one or
    % two sessions with one condition
    elseif length(name) == 2
        for i = 1:length(condNames)
            if startsWith(name{2},condNames{i}) == 1
                % saving the index of that condition
                firstCond = i;
            end
        end
        for i = 1:length(sessNames)
            if startsWith(name{1},sessNames{i}) == 1
                % saving the index of the first session
                firstSess = i;
            end
            if startsWith(name{1},sessNames{i}) == 0 && contains(name{1},sessNames{i}) == 1
                % saving the index of the second session
                secondSess = i;
                disp(sessNames{i})
            end
        end
        % if difficulty listed, saving that information
        if contains(name{1},'2T') == 1
            diff = 1;
        end
        if contains(name{1},'3T') == 1
            diff = 2;
        end
    % if three sections within name, assuming it is comparing two
    % conditions across all sessions
    elseif length(name) == 3
        for i = 1:length(condNames)
            if contains(name{1},condNames{i}) == 1
                % saving index of first condition
                firstCond = i;
            end
            if contains(name{3},condNames{i}) == 1
                % saving index of second condition
                secondCond = i;
            end
        end
    % if five section within the name, assuming it is comparing two
    % conditions across of or two sessions as specified in the first
    % section of the name
    elseif length(name) == 5
        for i = 1:length(condNames)
            if contains(name{1},condNames{i}) == 1
                % saving index of first condition
                firstCond = i;
            end
            if contains(name{4},condNames{i}) == 1
                % saving index of second condition
                secondCond = i;
            end
        end
        for i = 1:length(sessNames)
            if startsWith(name{1},sessNames{i}) == 1
                % saving index of first session
                firstSess = i;
            end
            if startsWith(name{1},sessNames{i}) == 0 && contains(name{1},sessNames{i}) == 1
                % saving index of second session
                secondSess = i;
            end
        end
        % if difficult listed, saving that information
        if contains(name{1},'2T') == 1
            diff = 1;
        end
        if contains(name{1},'3T') == 1
            diff = 2;
        end
    end
    % initializing variables used in loop
    contrasts =[];
    posCond = 0;
    negCond = 0;
    if exist("secondSess") == 0
        secondSess = 0;
    end
        
    % create contrast matrix
    for i = 1:length(labels)
        inds = find(labels(i,:) > 0);  
        for j = 1:length(inds)
            if length(name) == 1
                if inds(j) == firstCond
                    inds(j) = 1;
                    posCond = posCond+1;
                else
                    inds(j) = 0;
                end
            elseif length(name) == 2
                if inds(j) == firstCond && (i == firstSess || i == firstSess+3 )
                    inds(j) = 1;
                    posCond = posCond+1;
                elseif inds(j) == firstCond && secondSess > 0 && (i == secondSess || i == secondSess+3)
                    inds(j) = 1;
                    posCond = posCond+1;
                elseif exist("secondCond") && inds(j) == secondCond
                    inds(j) = -1;
                    negCond = negCond+1;
                else 
                    inds(j) = 0;
                end
             elseif length(name) == 3
                 if diff == 0
                    if inds(j) == firstCond 
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif exist("secondCond") && inds(j) == secondCond
                        inds(j) = -1;
                        negCond = negCond+1;
                    else 
                        inds(j) = 0;
                    end
                 end
                 if diff == 1
                    if inds(j) == firstCond && (i == 1  || i == 2 || i == 3)
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif exist("secondCond") && inds(j) == secondCond && (i == 1  || i == 2 || i == 3)
                        inds(j) = -1;
                        negCond = negCond+1;
                    else 
                        inds(j) = 0;
                    end
                 end
                 if diff == 2
                    if inds(j) == firstCond && (i == 4 || i == 5 || i == 6)
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif exist("secondCond") && inds(j) == secondCond && (i == 4 || i == 5 || i == 6)
                        inds(j) = -1;
                        negCond = negCond+1;
                    else 
                        inds(j) = 0;
                    end
                 end
              elseif length(name) == 5
                if diff == 0
                    if inds(j) == firstCond && (i == firstSess  || i == firstSess +3)
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif inds(j) == firstCond && secondSess > 0 && (i == secondSess || i == secondSess+3)
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif exist("secondCond") && inds(j) == secondCond && (i == firstSess  || i == firstSess +3 || i == secondSess || i == secondSess + 3)
                        inds(j) = -1;
                        negCond = negCond+1;
                    else 
                        inds(j) = 0;
                    end
                 end
                 if diff == 1
                    if inds(j) == firstCond && (i == firstSess   || i == secondSess )
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif exist("secondCond") && inds(j) == secondCond && (i == firstSess  || i == secondSess)
                        inds(j) = -1;
                        negCond = negCond+1;
                    else 
                        inds(j) = 0;
                    end
                 end
                 if diff == 2
                    if inds(j) == firstCond && (i == firstSess +3 || i == secondSess + 3)
                        inds(j) = 1;
                        posCond = posCond+1;
                    elseif exist("secondCond") && inds(j) == secondCond && (i == firstSess +3 || i == secondSess + 3)
                        inds(j) = -1;
                        negCond = negCond+1;
                    else 
                        inds(j) = 0;
                    end
                 end
            else
            inds = zeros(1,length(inds));
            end
        end
        contrasts = [contrasts,inds,Z];
    end
    posWeight = 1/posCond;
    negWeight = -1/negCond;
    for k = 1:length(contrasts)
        if contrasts(k) == 1
            contrasts(k) = posWeight;
        elseif contrasts(k) == -1
            contrasts(k) = negWeight;
        end
    end
    %adding weights to total
    allContrasts{c} = contrasts;
    clear Sessions firstCond secondCond firstSess secondSess posWeight negWeight cond
end

% look for missing data, create new matrix of full data only and save
% missing data 
m = 0;
yay = 0;
missing = {};
fullContrast = {};
fullNames = {};
for i = 1:length(allContrasts)
    if any(allContrasts{i}) == 0
        m = m+1;
        missing{m} = contrastNames{i};
    elseif any(allContrasts{i}) == 1
        yay = yay + 1;
        fullContrast{yay} = allContrasts{i};
        fullNames{yay} = contrastNames{i};
    end
end

filename = strcat(currentSubject,'missingContrasts','.txt')
T = table(missing)
f = fullfile(subjectOutputDirectory,filename)
fileID = fopen(f,'w')
writetable(T,f,'Delimiter',' ','WriteVariableNames',0);


%import contrasts into SPM
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));

for c = 1:length(fullNames)
    matlabbatch{3}.spm.stats.con.consess{c}.tcon.name = fullNames{c};
    matlabbatch{3}.spm.stats.con.consess{c}.tcon.convec = fullContrast{c};
    matlabbatch{3}.spm.stats.con.consess{c}.tcon.sessrep = 'none';
end

matlabbatch{3}.spm.stats.con.delete = 0;