% (inputDir, outputDir);
% motion correction for each subject
% step 1) use as reference the first volume of the middle run (e.g., run 1, 2, 3->first volume in run 2; or run 1, 2, 3, 4->first volume in run 3)
%         then align the first volume in other runs to it
% step 2) within each run, align the rest volumes to the first run
% generated in outputDir:
%       motion corrected nii files, mean resliced volume, motion correction parameters, motion graph
% if output nii files exist with same name, overwrite without any prompt
%
% inputDir ='.../xxx/'; trailing filesep does not matter
% outputDir = '.../xxx/'; % trailing filesep does not matter
% 
% note: 
%   uses SPM functions; SPM must be added to your matlab path: File -> Set Path... -> add with subfolders. 
%   tested under SPM 12 (with mac lion 10.7.5 and matlab 2012b)
%   if you use this job_function for the first time, consider running only one subject and check the results before processing all 
%
% author = jerryzhujian9@gmail.com
% date: December 10 2014, 11:13:30 AM CST
% inspired by http://www.aimfeld.ch/neurotools/neurotools.html
% https://www.youtube.com/playlist?list=PLcNEqVlhR3BtA_tBf8dJHG2eEcqitNJtw

%------------- BEGIN CODE --------------
function [output1,output2] = main(inputDir, outputDir, email)
% email is optional, if not provided, no email sent
% (re)start spm
spm('fmri')

startTime = ez.moment();
runFiles = ez.ls(inputDir,'_r\d\d.nii$'); % runFiles across all subjects
[dummy runFileNames] = cellfun(@(e) ez.splitpath(e),runFiles,'UniformOutput',false);
runFileNames = cellfun(@(e) regexp(e,'_', 'split'),runFileNames,'UniformOutput',false);
subjects = cellfun(@(e) e{end-1},runFileNames,'UniformOutput',false);  
subjects = ez.unique(subjects); % returns {'s0215';'s0216'}

for n = 1:ez.len(subjects)
    subject = subjects{n};
    ez.print(['Processing ' subject ' ...']);

    runFiles = ez.ls(inputDir, [subject '.*\.nii$']);  % runFiles for each subject
    refRun = floor((ez.len(runFiles)/2)+1); % e.g., floor((3/2+1)) = 2, floor((4/2+1)) = 3
    % reorder runFiles for input to motion correction module
    ind = [refRun,1:refRun-1,refRun+1:ez.len(runFiles)];
    runFiles = runFiles(ind);
    [dummy runFileNames] = cellfun(@(e) ez.splitpath(e),runFiles,'UniformOutput',false);

    load('mod_motion.mat');
    % create sessions in module
    matlabbatch{1}.spm.spatial.realign.estwrite.data=cell(1,ez.len(runFileNames));
    matlabbatch{1}.spm.spatial.realign.estwrite.data(:)={'<UNDEFINED>'};
    for m = 1:ez.len(runFileNames)
        runFileName = runFileNames{m};
        runVolumes = cellstr(spm_select('ExtList',inputDir,runFileName,[1:1000]));
        runVolumes = cellfun(@(e) ez.joinpath(inputDir,e),runVolumes,'UniformOutput',false);
        matlabbatch{1}.spm.spatial.realign.estwrite.data(1,m) = {runVolumes};
    end
    prefix = matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix;
    cd(outputDir);
    spm_jobman('run',matlabbatch);

    % jobman generates a mat file, not informative
    cellfun(@(e) ez.rm(ez.joinpath(inputDir,[e '.mat'])),runFileNames,'UniformOutput',false); 
    % move motion corrected files
    cellfun(@(e) ez.mv(ez.joinpath(inputDir,[prefix e '.nii']), outputDir),runFileNames,'UniformOutput',false);
    % move mean file
    ez.mv(ez.joinpath(inputDir,'mean*'), outputDir);
    % move motion parameter files
    cellfun(@(e) ez.mv(ez.joinpath(inputDir,['rp_' e '.txt']), ez.joinpath(outputDir,['m' e '.txt'])),runFileNames,'UniformOutput',false);
    % process motion graph
    psFile = ez.ls(outputDir,'\.ps$'){1};
    eps2pdf(psFile,ez.joinpath(outputDir,[subject '.pdf']));  %eps2pdf comes with ez.export, requires ghostscript
    ez.rm(psFile);
    clear matlabbatch;

    ez.pprint('****************************************'); % pretty colorful print
end
ez.pprint('Done!');
finishTime = ez.moment();
if exist('email','var'), try, batmail(mfilename, startTime, finishTime); end; end;
end % of main function
%------------- END OF CODE --------------