function result = main(roiNiiRegex)
% Description:
%       Uses afni functions to extract (roi nii --> --> xlsx, assuming everything needed in the pwd and extract mean betas)
%       The result should be equal to right-click->extract data->raw y in SPM map
%           if very close, due possibly to conversion of marsbar roi format
%       The betas = mean signal (aka raw intensity values, beta weights, parameter estimates, effect sizes) from your regions of interest
%           parameter estimate (2nd-level GLM regression coeffecient, fmri effect size), arbitary unit, averaged across voxels within the roi
%           Not likely to be standardized beta regression coeffecient
%       Reference at http://www.jessicagrahn.com/marsbar-extract-data.html
%       See Review-->Design-->Explore-->Files and factors to find out which beta is which
%
% Input:
%       roiNiiRegex: regex for roi nii files (default, '^ROI.*nii$')
% Output:
%       xlsx file with extracted betas (betas_extracted.xlsx, file name hard-coded)
%       returns a cell representing the xlsx result

if nargin<1, roiNiiRegex = '^ROI.*nii$'; end
roiNiiPath = ez.ls(pwd, roiNiiRegex);

if ischar(roiNiiPath), roiNiiPath = cellstr(roiNiiPath); end
SPMPath = 'SPM.mat';
folder = pwd;

header = cell(1,length(roiNiiPath));
result = [];
load(SPMPath); P = SPM.xY.P; P = cellfun(@(e) e(1:end-2), P, 'uniform', false);
for i = 1:length(roiNiiPath)
    roi = roiNiiPath{i};
    
    [~,roiName] = ez.splitpath(roi);
    header{1,i} = roiName;
    
    beta = [];  % a column
    for j = 1:length(P)
        cmd = ['3dmaskave -mask "', P{j}, '" -quiet "', roi, '"'];
        [sta, res] = system(cmd,'-echo');
        res = strsplit(res,'\n');
        res = str2num(res{3});
        beta = [beta; res];
    end
    result = [result,beta];

end % end for
result = [header;num2cell(result)];
load(SPMPath); P = SPM.xY.P; P = strrep(P,',','_');
result = [['ID';P] result];
T = cell2table(result(2:end,:));
T.Properties.VariableNames = result(1,:);
ez.savex(T, fullfile(folder,'betas_extracted.xlsx'));

end % end function