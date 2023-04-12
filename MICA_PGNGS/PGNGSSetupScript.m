%% Script to loop through MICA subjects and create SPM models
% Anna Jacobsen & Daniel Feldman
% 04/12/2023

%% The loop!


% setting up directories
CURDIR=pwd;
ExpDir = '/thalia/data/MEND2/MICA20/';
ScriptDir = '/thalia/data/MEND2/MICA20/FirstLevel/PGNGS/MICA_PGNGS_SPMscripts_04032023';

% potential way to import subject list from thalia
%   subjectList = fullfile(ExpDir,'Subjects','SubjectList.txt');
subjectList = readtable("SubjectList_FullModels.txt");

% designate number of sessions
sessions = 6;
resultsDir   = 'PGNGS_Full_Models';
runFileWild  = '^sw';
tempFrames   = 1:300;

for i = 1:height(subjectList)

    % designate current subject to use, converting to string 
    currentSubject = string(table2cell(subjectList(i,1)));

    % designate run folders in an array that we can call later
    for s = 1:sessions
        subjectDataDir{s} = fullfile(ExpDir,'ImagingData','SubjectsDerived',strcat(currentSubject,'_01'),strcat('func/PGNGS/run_0',string(s),'/'));
    end
    
    
    % creating output directory
    subjectOutputDirectory = fullfile(ExpDir,'FirstLevel','PGNGS',currentSubject,resultsDir);
    subjectOutputStupid = fullfile(ExpDir,'FirstLevel',currentSubject);
    mkdir(subjectOutputDirectory);
    
    % communicating start time
    theCLOCK=datestr(clock);
    fprintf('>>>>>>> STARTED WORKING ON %s at %s <<<<<<<<\n',subjectOutputDirectory,theCLOCK);
    
    % setting up model specifications, estimating, and bulding contrasts
    clear matlabbatch
    pgngsSpecs_job;
    cd(subjectOutputDirectory)
    save('pgngsSpecification','matlabbatch');
    spm_jobman('run',matlabbatch);
    
    % communicating end time
    theCLOCK=datestr(clock);
    fprintf('>>>>>>> FINISHED WORKING ON %s at %s <<<<<<<<\n',subjectOutputDirectory,theCLOCK);
    
    %Return to script folder
    cd(ScriptDir);

end



