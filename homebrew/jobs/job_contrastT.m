% (inputDir, preclean, together);
% specifies T-contrasts and generates spmT_000x.nii con_000x.nii
% output files:
%   for each subject, generates spmT_000x.nii con_000x.nii where x = #contrasts.  
%   SPM.mat in inputDir is also modified
%   spmT_000x.nii can be seen with Results/xjview; con_000x.nii can go to further analysis
% 
% inputDir
    % s0215_SPM
    %       beta_000x.nii
    %       SPM.mat
    % s0216_SPM
    %       beta_000x.nii
    %       SPM.mat
    %
    % s0215_contrastsT.mat
    % s0216_contrastsT.mat
    % 
    % these contrastsT.mat files could be generated by python script
    % there should be a separate file for each subject
    %     if not, say s0215_contrasts.mat is missing, s0215_SPM processing will be skipped/ignored
    % e.g., (there are 3 T-contrasts for subject 0215 across all runs)
    % clear all
    % names{1} = 'R11';
    % names{2} = 'R01';
    % names{3} = 'R00';
    % weights{1} = [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0];
    % weights{2} = [1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
    % weights{3} = [0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    % save s0215_contrasts;
    % clear all;
% outputDir = inputDir
    % s0215_SPM
    %       beta_000x.nii
    %       SPM.mat      <---modified
    %       spmT_000x.nii
    %       con_000x.nii
    % s0216_SPM
    %       beta_000x.nii
    %       SPM.mat      <---modified
    %       spmT_000x.nii
    %       con_000x.nii
    % ...
% preclean = 1/0; if 1 (default 1), delete existing contrasts before generating new ones; 0 not delete first.
%
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
function [output1,output2] = main(inputDir, preclean, together, email)
% email is optional, if not provided, no email sent
% (re)start spm
spm('fmri');
if ~exist('preclean','var'), preclean = 1; end
if ~exist('together','var'), together = 1; end

startTime = ez.moment();
contrastFiles = ez.ls(inputDir,'s\d\d\d\d_contrastsT\.mat$'); % contrastFiles across all subjects
[dummy contrastFileNames] = cellfun(@(e) ez.splitpath(e),contrastFiles,'UniformOutput',false);
contrastFileNames = cellfun(@(e) regexp(e,'_', 'split'),contrastFileNames,'UniformOutput',false);
subjects = cellfun(@(e) e{end-1},contrastFileNames,'UniformOutput',false);  
subjects = ez.unique(subjects); % returns {'s0215';'s0216'}

for n = 1:ez.len(subjects)
    subject = subjects{n};
    ez.print(['Processing ' subject ' ...']);

    load('mod_contrastT.mat');
    % fill out SPM.mat
    spmmat = ez.joinpath(inputDir, [subject '_SPM'], 'SPM.mat');
    matlabbatch{1}.spm.stats.con.spmmat = {spmmat};
    % fill out contrast sessions
    load(ez.joinpath(inputDir, [subject '_contrastsT.mat']));
    con = matlabbatch{1}.spm.stats.con.consess; % con structure
    matlabbatch{1}.spm.stats.con.consess = repmat([con], 1, ez.len(names)); % total number of contrasts read from contrasts.mat
    % fill out each contrast
    for ncon = 1:ez.len(names)
        matlabbatch{1}.spm.stats.con.consess{1,ncon}.tcon.name = names{ncon};
        matlabbatch{1}.spm.stats.con.consess{1,ncon}.tcon.weights = weights{ncon};
    end
    matlabbatch{1}.spm.stats.con.delete = preclean;
    cd(inputDir);
    save(['job_contrastT_' subject '.mat'], 'matlabbatch');
    clear names;
    clear weights;

    if together
        spm_jobman('run',matlabbatch);
    end

    clear matlabbatch;

    ez.pprint('****************************************'); % pretty colorful print
end
ez.pprint('Done!');
finishTime = ez.moment();
if exist('email','var') && together, try, jobmail(mfilename, startTime, finishTime); end; end;
end % of main function
%------------- END OF CODE --------------