%% Scoring RUME SART Time 2

% getting data directory
cd /Users/annajacobsen/boxdrive/1Projects_MEND2/1UtahProjects/09R61_RuMeChange/Databases/fMRI/R61_SubjectData/
MRIdir = dir;

% creating a list of subject directories 
k = 0;
for i=1:length(MRIdir)
    if MRIdir(i).isdir == 1
        if startsWith(MRIdir(i).name,'3') == 1 || startsWith(MRIdir(i).name,'4') == 1 || startsWith(MRIdir(i).name,'5') == 1 
            k = k+1;
            subjects{k} = MRIdir(i).name;
        end
    end
end

%% importing raw spreadsheets

for i = 1:length(subjects)
    subdir = dir(subjects{1,i});
    for k = 1:length(subdir)
        if contains(subdir(k).name,'Visit15') == 1 || contains(subdir(k).name,'Visit 15') == 1 || contains(subdir(k).name,'Visit_15') == 1
            visitdir = dir(fullfile(subdir(k).folder,subdir(k).name));
            for j = 1:length(visitdir)
                if contains(visitdir(j).name,'SART') == 1
                    taskdir = dir(fullfile(visitdir(j).folder,visitdir(j).name));
                        for l = 1:length(taskdir)
                            if contains(taskdir(l).name,'.xlsx')
                                filename = fullfile(taskdir(l).folder,taskdir(l).name);
                                subjects{2,i} = readtable(filename);
                                break
                            else
                                subjects{2,i} = 'No SART spreadsheet';
                            end
                        end
                        break
                else
                    subjects{2,i} = 'No SART folder';
                end
            end
            break
        else 
            subjects{2,i} = 'No time 2 folder';
        end
    end
end

%% counting usable data

N = 0;
for i = 1:length(subjects)
    if strcmp(class(subjects{2,i}),'table') == 1
        N = N+1;
    end
end

%% scoring performance

for i=1:length(subjects)
    if strcmp(class(subjects{2,i}),'table') == 1
        T = subjects{2,i};
        scored = zeros(height(T),6);
        % finding indices of when each run occurs
        inds = find(diff(T.START1_OnsetTime))+1;
        if length(inds) == 1
            scored(1:inds(1),1) = 1;
            scored(inds(1):end,1) = 2;
        end
        if length(inds) == 2
            scored(1:inds(1),1) = 1;
            scored(inds(1):inds(2),1) = 2;
            scored(inds(2):end,1) = 3;
        end
        % finding when NoGo occurs
        for j = 1:length(scored(:,1))
            if isnan(T.Mask_RESP(j)) == 1 && isnan(T.wordout_RESP(j)) == 1
                scored(j,2) = 1;
            end
        end
        % finding/converting Correct No Go onset times
        for j = 1:length(scored(:,1))
            if isnan(T.CorrectResponse(j)) == 1 && scored(j,2) == 1
                if scored(j,1) == 1
                    scored(j,3) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-8;
                end
                if scored(j,1) == 2
                    scored(j,3) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-8;
                end
                if scored(j,1) == 3
                    scored(j,3) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-8;
                end
            end
        end
        % finding/converting Correct go onset times
        for j = 1:length(scored(:,1))
            if T.CorrectResponse(j) == 2 && scored(j,2) == 0
                if scored(j,1) == 1
                    scored(j,4) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-8;
                end
                if scored(j,1) == 2
                    scored(j,4) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-8;
                end
                if scored(j,1) == 3
                    scored(j,4) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-8;
                end
            end
        end    
        % finding/converting Error Commission onset times
        for j = 1:length(scored(:,1))
            if isnan(T.CorrectResponse(j)) == 1 && scored(j,2) == 0
                if scored(j,1) == 1
                    scored(j,5) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-8;
                end
                if scored(j,1) == 2
                    scored(j,5) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-8;
                end
                if scored(j,1) == 3
                    scored(j,5) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-8;
                end
            end
        end
        % finding/converting Error Omission onset times
        for j = 1:length(scored(:,1))
            if T.CorrectResponse(j) == 2 && scored(j,2) == 1
                if scored(j,1) == 1
                    scored(j,6) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-8;
                end
                if scored(j,1) == 2
                    scored(j,6) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-8;
                end
                if scored(j,1) == 3
                    scored(j,6) = ((T.wordout_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-8;
                end
            end
        end
        % saving scored data
        subjects{3,i} = array2table(scored,'VariableNames',{'Run';'NoGo';'CorrectNoGo';'CorrectGo';'ErrorCommissions';'ErrorOmissions'});
    else 
        subjects{3,i} = 'Unable to score';
    end
end

%% exporting scored performance data

filename = 'PerformanceOnsetsTime2.xlsx';
for i = 1:length(subjects)
    if strcmp(class(subjects{2,i}),'table') == 1
        writetable(subjects{3,i},filename,'WriteVariableNames',0,'Sheet',subjects{1,i})
    end
end

%% scoring thought probes

for i=1:length(subjects)
    if strcmp(class(subjects{2,i}),'table') == 1
        T = subjects{2,i};
        scored = zeros(height(T),5);
        % finding indices of when each run occurs
        inds = find(diff(T.START1_OnsetDelay))+1;
        if length(inds) == 1
            scored(1:inds(1),1) = 1;
            scored(inds(1):end,1) = 2;
        end
        if length(inds) == 2
            scored(1:inds(1),1) = 1;
            scored(inds(1):inds(2),1) = 2;
            scored(inds(2):end,1) = 3;
        end
        % Task 
        for j = 1:length(scored(:,1))
            if T.ThoughtProbe_RESP(j) == 1
                if scored(j,1) == 1
                    scored(j,2) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-12;
                end
                if scored(j,1) == 2
                    scored(j,2) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-12;
                end
                if scored(j,1) == 3
                    scored(j,2) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-12;
                end
            end
        end
        % Rumination
        for j = 1:length(scored(:,1))
            if T.ThoughtProbe_RESP(j) == 2
                if scored(j,1) == 1
                    scored(j,3) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-12;
                end
                if scored(j,1) == 2
                    scored(j,3) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-12;
                end
                if scored(j,1) == 3
                    scored(j,3) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-12;
                end
            end
        end
        % Other
        for j = 1:length(scored(:,1))
            if T.ThoughtProbe_RESP(j) == 3
                if scored(j,1) == 1
                    scored(j,4) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-12;
                end
                if scored(j,1) == 2
                    scored(j,4) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-12;
                end
                if scored(j,1) == 3
                    scored(j,4) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-12;
                end
            end
        end
        % Missing
        for j = 1:length(scored(:,1))
            if isempty(T.ThoughtProbe_RESP(j)) == 1 && strcmp(T.word(j),'Yes') == 1
                if scored(j,1) == 1
                    scored(j,5) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(1))/1000)-12;
                end
                if scored(j,1) == 2
                    scored(j,5) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(1)))/1000)-12;
                end
                if scored(j,1) == 3
                    scored(j,5) = ((T.ThoughtProbe_OnsetTime(j)-T.wordout_OnsetTime(inds(2)))/1000)-12;
                end
            end
        end
        % saving scored data
        subjects{4,i} = array2table(scored,'VariableNames',{'Run';'Task';'Rumination';'Other';'Missing'});
    else 
        subjects{4,i} = 'Unable to score';
    end
end

%% exporting scored thought probe data

filename = 'ThoughtProbeOnsetsTime2.xlsx';
for i = 1:length(subjects)
    if strcmp(class(subjects{2,i}),'table') == 1
        writetable(subjects{4,i},filename,'WriteVariableNames',1,'Sheet',subjects{1,i})
    end
end

%% evaluating performance data

perf = 0;
thot = 0;

for i=1:length(subjects)
    if strcmp(class(subjects{2,i}),'table') == 1
        if any(table2array(subjects{3,i}(:,3))) == 1 && any(table2array(subjects{3,i}(:,4))) == 1 && any(table2array(subjects{3,i}(:,5))) == 1 && any(table2array(subjects{3,i}(:,6))) == 1
            perf = perf+1;
            usable{perf} = subjects{1,i};
        end
        if any(table2array(subjects{4,i}(:,2))) == 1 && any(table2array(subjects{3,i}(:,3))) == 1 && any(table2array(subjects{3,i}(:,4))) == 1 && any(table2array(subjects{3,i}(:,5))) == 1
            thot = thot+1;
        end
    end
end

%%



