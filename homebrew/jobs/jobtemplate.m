% (inputDir, outputDir, parameters, together);
% 
% if output nii files exist with same name, overwrite without any prompt
%
% inputDir ='.../xxx/'; trailing filesep does not matter
% outputDir = '.../xxx/'; % trailing filesep does not matter
% parameters = {nslices, tr(seconds), sliceorder, refslice};
%       e.g.,  {26, 2.5, [1:2:26 2:2:26], 25}
% optional input: together = 0/1 (default 1) if 0 only generates job_.mat files, 1 run the jobs and clean up afterwards
% 
% note: 
%   uses SPM functions; SPM must be added to your matlab path: File -> Set Path... -> add with subfolders. 
%   tested under SPM 12-6225 (with mac lion 10.7.5 and matlab 2012b)
%   if you use this job_function for the first time, consider running only one subject and check the results before processing all 
%
% author = jerryzhujian9@gmail.com
% date: December 10 2014, 11:13:30 AM CST
% inspired by http://www.aimfeld.ch/neurotools/neurotools.html
% https://www.youtube.com/playlist?list=PLcNEqVlhR3BtA_tBf8dJHG2eEcqitNJtw

%------------- BEGIN CODE --------------
function [output1,output2] = main(inputDir, outputDir, parameters, together, email)
% email is optional, if not provided, no email sent
% (re)start spm
spm('fmri');
if ~exist('together','var'), together = 1; end
[nslices, tr, sliceorder, refslice] = parameters{:};

startTime = ez.moment();
runFiles = ez.ls(inputDir,'s\d\d\d\d_r\d\d\.nii$'); % runFiles across all subjects
[dummy runFileNames] = cellfun(@(e) ez.splitpath(e),runFiles,'UniformOutput',false);
runFileNames = cellfun(@(e) regexp(e,'_', 'split'),runFileNames,'UniformOutput',false);
subjects = cellfun(@(e) e{end-1},runFileNames,'UniformOutput',false);  
subjects = ez.unique(subjects); % returns {'s0215';'s0216'}

for n = 1:ez.len(subjects)
    subject = subjects{n};
    ez.print(['Processing ' subject ' ...']);

    runFiles = ez.ls(inputDir, [subject '_r\d\d\.nii$']);  % runFiles for one subject
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
    save(['job_motion_' subject '.mat'], 'matlabbatch');

    if together
        spm_jobman('run',matlabbatch);
        % jobman generates a mat file, not informative
        cellfun(@(e) ez.rm(ez.joinpath(inputDir,[e '.mat'])),runFileNames,'UniformOutput',false); 
        % move motion corrected files
        cellfun(@(e) ez.mv(ez.joinpath(inputDir,[prefix e '.nii']), outputDir),runFileNames,'UniformOutput',false);
        % move mean file
        ez.mv(ez.joinpath(inputDir,'mean*'), outputDir);
        % move motion parameter files
        cellfun(@(e) ez.mv(ez.joinpath(inputDir,['rp_' e '.txt']), ez.joinpath(outputDir,['m' e '.txt'])),runFileNames,'UniformOutput',false);
        % process graph
        psFile = ez.ls(outputDir,'\.ps$'){1};
        eps2pdf(psFile,ez.joinpath(outputDir,[subject '_.pdf']));  %eps2pdf comes with ez.export, requires ghostscript
        ez.rm(psFile);
    end

    clear matlabbatch;

    ez.pprint('****************************************'); % pretty colorful print
end
ez.pprint('Done!');
finishTime = ez.moment();
if exist('email','var'), try, batmail(mfilename, startTime, finishTime); end; end;
end % of main function
%------------- END OF CODE --------------