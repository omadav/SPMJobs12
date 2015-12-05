function con = spm_config_contrasts
% Configuration file for contrast jobs
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% Darren Gitelman
% $Id: spm_config_contrasts.m 948 2007-10-15 21:37:49Z Darren $


%_______________________________________________________________________


spm.type = 'files';
spm.name = 'Select SPM.mat';
spm.tag  = 'spmmat';
spm.num  = [1 1];
spm.filter  = 'mat';
spm.ufilter = '^SPM\.mat$';
spm.help   = {'Select SPM.mat file for contrasts'};

sessrep.type = 'menu';
sessrep.name = 'Replicate over sessions';
sessrep.tag  = 'sessrep';
sessrep.labels = {'Don''t replicate','Replicate','Create per session','Both'};
sessrep.values = {'none','repl','sess','both'};
sessrep.val  = {'none'};
sessrep.help = {['If there are multiple sessions with identical conditions, ' ...
                 'one might want to specify contrasts which are identical over ',...
                 'sessions. This can be done automatically based on the contrast '...
                 'spec for one session.'],...
                ['Contrasts can be either replicated (thus testing average ' ...
                 'effects over sessions) or created per session. In both ' ...
                 'cases, zero padding up to the length of each session ' ...
                 'and the block effects is done automatically.']};

name.type    = 'entry';
name.name    = 'Name';
name.tag     = 'name';
name.strtype = 's';
name.num     = [1 1];
name.help    = {'Name of contrast'};

tconvec.type    = 'entry';
tconvec.name    = 'T contrast vector';
tconvec.tag     = 'convec';
tconvec.strtype = 'e';
tconvec.num     = [1 Inf];
tconvec.help    = {[...
    'Enter T contrast vector. This is done similarly to the ',...
    'SPM2 contrast manager. A 1 x n vector should be entered ',...
    'for T-contrasts.']};

fconvec.type    = 'entry';
fconvec.name    = 'F contrast vector';
fconvec.tag     = 'convec';
fconvec.strtype = 'e';
fconvec.num     = [Inf Inf];
fconvec.help    = {[...
    'Enter F contrast vector. This is done similarly to the ',...
    'SPM2 contrast manager. One or multiline contrasts ',...
    'may be entered.']};

fconvecs.type = 'repeat';
fconvecs.name = 'Contrast vectors';
fconvecs.tag  = 'convecs';
fconvecs.values = {fconvec};
fconvecs.help = {...
'F contrasts are defined by a series of vectors.'};

tcon.type   = 'branch';
tcon.name   = 'T-contrast';
tcon.tag    = 'tcon';
tcon.val    = {name,tconvec,sessrep};
tcon.help = {...
'* Simple one-dimensional contrasts for an SPM{T}','',[...
'A simple contrast for an SPM{T} tests the null hypothesis c''B=0 ',...
'against the one-sided alternative c''B>0, where c is a column vector. '],'',[...
'    Note that throughout SPM, the transpose of the contrast weights is ',...
'used for display and input. That is, you''ll enter and visualise c''. ',...
'For an SPM{T} this will be a row vector.'],'',[... 
'For example, if you have a design in which the first two columns of ',...
'the design matrix correspond to the effects for "baseline" and ',...
'"active" conditions respectively, then a contrast with weights ',...
'c''=[-1,+1,0,...] (with zero weights for any other parameters) tests ',...
'the hypothesis that there is no "activation" (the parameters for both ',...
'conditions are the same), against the alternative that there is some ',...
'activation (i.e. the parameter for the "active" condition is greater ',...
'than that for the "baseline" condition). The resulting SPM{T} ',...
'(created by spm_getSPM.m) is a statistic image, with voxel values the ',...
'value of the t-statistic for the specified contrast at that location. ',...
'Areas of the SPM{T} with high voxel values indicate evidence for ',...
'"activation". To look for areas of relative "de-activation", the ',...
'inverse contrast could be used c''=[+1,-1,0,...].'],'',[...
'Similarly, if you have a design where the third column in the design ',...
'matrix is a covariate, then the corresponding parameter is ',...
'essentially a regression slope, and a contrast with weights ',...
'c''=[0,0,1,0,...] (with zero weights for all parameters but the third) ',...
'tests the hypothesis of zero regression slope, against the ',...
'alternative of a positive slope. This is equivalent to a test no ',...
'correlation, against the alternative of positive correlation. If ',...
'there are other terms in the model beyond a constant term and the ',...
'covariate, then this correlation is apartial correlation, the ',...
'correlation between the data Y and the covariate, after accounting ',...
'for the other effects.']};

fcon.type   = 'branch';
fcon.name   = 'F-contrast';
fcon.tag    = 'fcon';
fcon.val    = {name,fconvecs,sessrep};
fcon.help   = {...
'* Linear constraining matrices for an SPM{F}',...
'',[...
'The null hypothesis c''B=0 can be thought of as a (linear) constraint ',...
'on the full model under consideration, yielding a reduced model. ',...
'Taken from the viewpoint of two designs, with the full model an ',...
'extension of the reduced model, the null hypothesis is that the ',...
'additional terms in the full model are redundent.'],...
'',[...
'Statistical inference proceeds by comparing the additional variance ',...
'explained by full design over and above the reduced design to the ',...
'error variance (of the full design), an "Extra Sum-of-Squares" ',...
'approach yielding an F-statistic for each voxel, whence an SPM{F}.'],...
'',...
'This is useful in a number of situations:',...
'',...
'* Two sided tests',...
'',[...
'The simplest use of F-contrasts is to effect a two-sided test of a ',...
'simple linear contrast c''B, where c is a column vector. The SPM{F} is ',...
'the square of the corresponding SPM{T}. High values of the SPM{F} ',...
'therefore indicate evidence against the null hypothesis c''B=0 in ',...
'favour of the two-sided alternative c''B~=0.'],...
'',...
'* General linear hypotheses',...
'',[...
'Where the contrast weights is a matrix, the rows of the (transposed) ',...
'contrast weights matrix c'' must define contrasts in their own right, ',...
'and the test is effectively simultaneously testing the null ',...
'hypotheses associated with the individual component contrasts with ',...
'weights defined in the rows. The null hypothesis is still c''B=0, but ',...
'since c is a matrix, 0 here is a zero vector rather than a scalar ',...
'zero, asserting that under the null hypothesis all the component ',...
'hypotheses are true.'],...
'',[...
'For example: Suppose you have a language study with 3 word categories ',...
'(A,B & C), and would like to test whether there is any difference ',...
'at all between the three levels of the "word category" factor.'],...
'',...
'The design matrix might look something like:',...
'',...
'         [ 1 0 0 ..]',...
'         [ : : : ..]',...
'         [ 1 0 0 ..]',...
'         [ 0 1 0 ..]',...
'    X =  [ : : : ..]',...
'         [ 0 1 0 ..]',...
'         [ 0 0 1 ..]',...
'         [ : : : ..]',...
'         [ 0 0 1 ..]',...
'         [ 0 0 0 ..]',...
'         [ : : : ..]',...
'',[...
' ...with the three levels of the "word category" factor modelled in the ',...
' first three columns of the design matrix.'],...
'',...
'The matrix of contrast weights will look like:',...
'',...
' c'' = [1 -1  0 ...;',...
'       0  1 -1 ...]',...
'',[...
'Reading the contrasts weights in each row of c'', we see that row 1 ',...
'states that category A elicits the same response as category B, row 2 ',...
'that category B elicits the same response as category C, and hence ',...
'together than categories A, B & C all elicit the same response.'],...
'',[...
'The alternative hypothesis is simply that the three levels are not ',...
'all the same, i.e. that there is some difference in the paraeters for ',...
'the three levels of the factor: The first and the second categories ',...
'produce different brain responses, OR the second and third ',...
'categories, or both.'],...
'',[...
'In other words, under the null hypothesis (the categories produce the ',...
'same brain responses), the model reduces to one in which the three ',...
'level "word category" factor can be replaced by a single "word" ',...
'effect, since there is no difference in the parameters for each ',...
'category. The corresponding design matrix would have the first three ',...
'columns replaced by a single column that is the sum (across rows) of ',...
'the first three columns in the design matric above, modelling the ',...
'brain response to a word, whatever is the category. The F-contrast ',...
'above is in fact testing the hypothesis that this reduced design ',...
'doesn''t account for significantly less variance than the full design ',...
'with an effect for each word category.'],...
'',[...
'Another way of seeing that, is to consider a reparameterisation of ',...
'the model, where the first column models effects common to all three ',...
'categories, with the second and third columns modelling the ',...
'differences between the three conditions, for example:'],...
'',...
'         [ 1  1  0 ..]',...
'         [ :  :  : ..]',...
'         [ 1  1  0 ..]',...
'         [ 1  0  1 ..]',...
'    X =  [ :  :  : ..]',...
'         [ 1  0  1 ..]',...
'         [ 1 -1 -1 ..]',...
'         [ :  :  : ..]',...
'         [ 1 -1 -1 ..]',...
'         [ 0  0  0 ..]',...
'         [ :  :  : ..]',...
'',...
'In this case, an equivalent F contrast is of the form',...
' c'' = [ 0 1 0 ...;',...
'        0 0 1 ...]',[...
'and would be exactly equivalent to the previous contrast applied to ',...
'the previous design. In this latter formulation, you are asking ',...
'whewher the two columns modelling the "interaction space" account for ',...
'a significant amount of variation (variance) of the data. Here the ',...
'component contrasts in the rows of c'' are simply specifying that the ',...
'parameters for the corresponding rows are are zero, and it is clear ',...
'that the F-test is comparing this full model with a reduced model in ',...
'which the second and third columns of X are omitted.'],...
'',...
'    Note the difference between the following two F-contrasts:',...
'         c'' = [ 0 1 0 ...;     (1)',...
'                0 0 1 ...]',... 
'     and',...
'         c'' = [ 0 1 1 ...]     (2)',...
'',[...
'    The first is an F-contrast, testing whether either of the ',... 
'parameters for the effects modelled in the 2nd & 3rd columns of the ',...
'design matrix are significantly different from zero. Under the null ',...
'hypothesis c''B=0, the first contrast imposes a two-dimensional ',... 
'constraint on the design. The second contrast tests whether the SUM ',...
'of the parameters for the 2nd & 3rd columns is significantly ',... 
'different from zero. Under the null hypothesis c''B=0, this second ',...
'contrast only imposes a one dimensional constraint on the design.'],... 
'',[...
'    An example of the difference between the two is that the first ',... 
'contrast would be sensitive to the situation where the 2nd & 3rd ',...
'parameters were +a and -a, for some constant a, wheras the second ',...
'contrast would not detect this, since the parameters sum to zero.'],... 
'',[...
'The test for an effect of the factor "word category" is an F-test ',...
'with 3-1=2 "dimensions", or degrees of freedom.'],...
'',...
'* Testing the significance of effects modelled by multiple columns',...
'',[...
'A conceptially similar situation arises when one wonders whether a ',...
'set of coufound effects are explaining any variance in the data. One ',...
'important advantage of testing the with F contrasts rather than one ',...
'by one using SPM{T}''s is the following. Say you have two covariates ',...
'that you would like to know whether they can "predict" the brain ',...
'responses, and these two are correlated (even a small correlation ',...
'would be important in this instance). Testing one and then the other ',...
'may lead you to conclude that there is no effect. However, testing ',...
'with an F test the two covariates may very well show a not suspected ',...
'effect. This is because by testing one covariate after the other, one ',...
'never tests for what is COMMON to these covariates (see Andrade et ',...
'al, Ambiguous results in functional neuroimaging, NeuroImage, 1999).'],...
'','',[...
'More generally, F-tests reflect the usual analysis of variance, while ',...
't-tests are traditionally post hoc tests, useful to see in which ',...
'direction is an effect going (positive or negative). The introduction ',...
'of F-tests can also be viewed as a first means to do model selection.'],...
'','',[...
'Technically speaking, an F-contrast defines a number of directions ',...
'(as many as the rank of the contrast) in the space spanned by the ',...
'column vectors of the design matrix. These directions are simply ',...
'given by X*c if the vectors of X are orthogonal, if not, the space ',...
'define by c is a bit more complex and takes care of the correlation ',...
'within the design matrix. In essence, an F-contrast is defining a ',...
'reduced model by imposing some linear constraints (that have to be ',...
'estimable, see below) on the parameters estimates. Sometimes, this ',...
'reduced model is simply made of a subset of the column of the ',...
'original design matrix but generally, it is defined by a combination ',...
'of those columns. (see spm_FcUtil for what (I hope) is an efficient ',...
'handling of F-contrats computation).']};



% Column-wise contrast definition for fancy fMRI designs
%_______________________________________________________________________

conweight.type    = 'entry';
conweight.name    = 'Contrast weight';
conweight.tag     = 'conweight';
conweight.strtype = 'e';
conweight.num     = [1 1];
conweight.help    = {'The contrast weight for the selected column.'};

colcond.type    = 'entry';
colcond.name    = 'Condition #';
colcond.tag     = 'colcond';
colcond.strtype = 'e';
colcond.num     = [1 1];
colcond.help    = {['Select which condition function set is to be contrasted.']};

colbf.type    = 'entry';
colbf.name    = 'Basis function #';
colbf.tag     = 'colbf';
colbf.strtype = 'e';
colbf.num     = [1 1];
colbf.help    = {['Select which basis function from the basis' ...
		  ' function set is to be contrasted.']};

colmod.type    = 'entry';
colmod.name    = 'Parametric modulation #';
colmod.tag     = 'colmod';
colmod.strtype = 'e';
colmod.num     = [1 1];
colmod.help    = {['Select which parametric modulation is to be contrasted.' ...
		   ' If there is no time/parametric modulation, enter' ...
		   ' "1". If there are both time and parametric modulations, '...
		   'then time modulation comes before parametric modulation.']}; 

colmodord.type    = 'entry';
colmodord.name    = 'Parametric modulation order';
colmodord.tag     = 'colmodord';
colmodord.strtype = 'e';
colmodord.num     = [1 1];
colmodord.help    = {'Order of parametric modulation to be contrasted. ','', ...
		     '0 - the basis function itself, 1 - 1st order mod etc'};
		    
colconds.type   = 'branch';
colconds.name   = 'Contrast entry';
colconds.tag    = 'colconds';
colconds.val    = {conweight,colcond,colbf,colmod,colmodord};

colcondrep.type   = 'repeat';
colcondrep.name   = 'T contrast for conditions';
colcondrep.tag    = 'colcondrep';
colcondrep.values = {colconds};
colcondrep.num    = [1 Inf];
colcondrep.help   = {'Assemble your contrast column by column.'};

colreg = tconvec;
colreg.name    = 'T contrast for extra regressors';
colreg.tag     = 'colreg';
colreg.help    = {...
['Enter T contrast vector for extra regressors.']};

coltype.type   = 'choice';
coltype.name   = 'Contrast columns';
coltype.tag    = 'coltype';
coltype.values = {colcondrep, colreg};
coltype.help   = {...
['Contrasts can be specified either over conditions or over extra regressors.']};

sessions.type    = 'entry';
sessions.name    = 'Session(s)';
sessions.tag     = 'sessions';
sessions.strtype = 'e';
sessions.num     = [1 Inf];
sessions.help    = {...
['Enter session number(s) for which this contrast should be created. If' ...
 ' more than one session number is specified, the contrast will be an' ...
 ' average contrast over the specified conditions or regressors from these' ...
 ' sessions.']};

tconsess.type = 'branch';
tconsess.name = 'T-contrast (cond/sess based)';
tconsess.tag  = 'tconsess';
tconsess.val  = {name,coltype,sessions};
tconsess.modality = {'FMRI'};
tconsess.help = {...
['Define a contrast in terms of conditions or regressors instead of' ...
 ' columns of the design matrix. This allows to create contrasts automatically' ...
 ' even if some columns are not always present (e.g. parametric modulations).'], ...
'', ...
'Each contrast column can be addressed by specifying', ...
'* session number', ...
'* condition number', ...
'* basis function number', ...
'* parametric modulation number and', ...
'* parametric modulation order.', ...
'', ...
['If the design is specified without time or parametric modulation, SPM' ...
 ' creates a "pseudo-modulation" with order zero. To put a contrast weight' ...
 ' on a basis function one therefore has to enter "1" for parametric' ...
 ' modulation number and "0" for parametric modulation order.'], ...
'', ...
['Time and parametric modulations are not distinguished internally. If' ...
 ' time modulation is present, it will be parametric modulation "1", and' ...
 ' additional parametric modulations will be numbered starting with "2".'], ...
'', ...
tcon.help{:}};

consess.type = 'repeat';
consess.name = 'Contrast Sessions';
consess.tag  = 'consess';
consess.values  = {tcon,fcon,tconsess};
consess.help = {'contrast'};
consess.help = {[...
'For general linear model Y = XB + E with data Y, desgin matrix X, ',...
'parameter vector B, and (independent) errors E, a contrast is a ',...
'linear combination of the parameters c''B. Usually c is a column ',...
'vector, defining a simple contrast of the parameters, assessed via an ',...
'SPM{T}. More generally, c can be a matrix (a linear constraining ',...
'matrix), defining an "F-contrast" assessed via an SPM{F}.'],'',[...
'The vector/matrix c contains the contrast weights. It is this ',...
'contrast weights vector/matrix that must be specified to define the ',...
'contrast. The null hypothesis is that the linear combination c''B is ',...
'zero. The order of the parameters in the parameter (column) vector B, ',...
'and hence the order to which parameters are referenced in the ',...
'contrast weights vector c, is determined by the construction of the ',...
'design matrix.'],'',[...
'There are two types of contrast in SPM: simple contrasts for SPM{T}, ',...
'and "F-contrasts" for SPM{F}.'],'',[...
'For a thorough theoretical treatment, see the Human Brain Function book ',...
'and the statistical literature referenced therein.'],...
'','',...
'* Non-orthogonal designs',...
'',[...
'Note that parameters zero-weighted in the contrast are still included ',...
'in the model. This is particularly important if the design is not ',...
'orthogonal (i.e. the columns of the design matrix are not ',...
'orthogonal). In effect, the significance of the contrast is assessed ',...
'*after* accounting for the other effects in the design matrix. Thus, ',...
'if two covariates are correlated, testing the significance of the ',...
'parameter associated with one will only test for the part that is not ',...
'present in the second covariate. This is a general point that is also ',...
'true for F-contrasts. See Andrade et al, Ambiguous results in ',...
'functional neuroimaging, NeuroImage, 1999, for a full description of ',...
'the effect of non othogonal design testing.'],...
'','',...
'* Estimability',...
'',[...
'The contrast c''B is estimated by c''b, where b are the parameter ',...
'estimates given by b=pinv(X)*Y.'],...
'',[...
'However, if a design is rank-deficient (i.e. the columns of the ',...
'design matrix are not linearly independent), then the parameters are ',...
'not unique, and not all linear combinations of the parameter are ',...
'valid contrasts, since contrasts must be uniquely estimable.'],...
'',[...
'A weights vector defines a valid contrast if and only if it can be ',...
'constructed as a linear combination of the rows of the design matrix. ',...
'That is c'' (the transposed contrast vector - a row vector) is in the ',...
'row-space of the design matrix.'],...
'',[...
'Usually, a valid contrast will have weights that sum to zero over the ',...
'levels of a factor (such as condition).'],...
'',[...
'A simple example is a simple two condition design including a ',...
'constant, with design matrix'],...
'',...
'          [ 1 0 1 ]',...
'          [ : : : ]',...
'     X =  [ 1 0 1 ]',...
'          [ 0 1 1 ]',...
'          [ : : : ]',...
'          [ 0 1 1 ]',...
'',[...
'The first column corresponds to condition 1, the second to condition ',...
'2, and the third to a constant (mean) term. Although there are three ',...
'columns to the design matrix, the design only has two degrees of ',...
'freedom, since any one column can be derived from the other two (for ',...
'instance, the third column is the sum of the first two). There is no ',...
'unique set of parameters for this model, since for any set of ',...
'parameters adding a constant to the two condition effects and ',...
'subtracting it from the constant effect yields another set of viable ',...
'parameters. However, the difference between the two condition effects ',...
'is uniquely estimated, so c''=[-1,+1,0] does define a contrast.'],...
'',[...
'If a parameter is estimable, then the weights vector with a single ',...
'"1" corresponding to that parameter (and zero elsewhere) defines a ',...
'valid contrast.'],...
'','',...
'* Multiple comparisons',...
'',[...
'Note that SPM implements no corrections to account for you looking at ',...
'multiple contrasts.'],...
'',[...
'If you are interested in a set of hypotheses that together define a ',...
'consistent question, then you should account for this when assessing ',...
'the individual contrasts. A simple Bonferroni approach would assess N ',...
'simultaneous contrasts at significance level alpha/N, where alpha is ',...
'the chosen significance level (usually 0.05).'],...
'',[...
'For two sided t-tests using SPM{T}s, the significance level should ',...
'be halved. When considering both SPM{T}s produced by a contrast and ',...
'it''s inverse (the contrast with negative weights), to effect a ',...
'two-sided test to look for both "increases" and "decreases", you ',...
'should review each SPM{T} at at level 0.05/2 rather than 0.05. (Or ',...
'consider an F-contrast!)'],...
'','',...
'* Contrast images and ESS images',...
'',[...
'For a simple contrast, SPM (spm_getSPM.m) writes a contrast image: ',...
'con_????.{img,nii}, with voxel values c''b. (The ???? in the image ',...
'names are replaced with the contrast number.) These contrast images ',...
'(for appropriate contrasts) are suitable summary images of an effect ',...
'at this level, and can be used as input at a higher level when ',...
'effecting a random effects analysis. See spm_RandFX.man for further ',...
'details.'],...
'',[...
'For an F-contrast, SPM (spm_getSPM.m) writes the Extra Sum-of-Squares ',...
'(the difference in the residual sums of squares for the full and ',...
'reduced model) as ess_????.{img,nii}. (Note that the ',...
'ess_????.{img,nii} and SPM{T,F}_????.{img,nii} images are not ',...
'suitable input for a higher level analysis.)']};

delete.type = 'menu';
delete.name = 'Delete existing contrasts';
delete.tag  = 'delete';
delete.labels = {'Yes', 'No'};
delete.values = {1, 0};
delete.val    = {0};

con.type = 'branch';
con.name = 'Contrast Manager';
con.tag  = 'con';
con.val = {spm,consess,delete};
con.prog   = @setupcon;
con.help = {'Set up T and F contrasts.'};

%-----------------------------------------------------------------------
function setupcon(varargin)

wd  = pwd;
job = varargin{1};

% Change to the analysis directory
%-----------------------------------------------------------------------
if ~isempty(job)
    try
        pth = fileparts(job.spmmat{:});
        cd(char(pth));
        fprintf('   Changing directory to: %s\n',char(pth));
    catch
        error('Failed to change directory. Aborting contrast setup.')
    end
end

% Load SPM.mat file
%-----------------------------------------------------------------------
tmp=load(job.spmmat{:});
SPM=tmp.SPM;

if ~strcmp(pth,SPM.swd)
    warning(['Path to SPM.mat: %s\n and SPM.swd: %s\n differ, using current ' ...
             'SPM.mat location as new working directory.'], pth, ...
            SPM.swd);
    SPM.swd = pth;
end;

if job.delete && isfield(SPM,'xCon')
    for k=1:numel(SPM.xCon)
        [p n e v] = spm_fileparts(SPM.xCon(k).Vcon.fname);
        switch e,
            case '.img'
                spm_unlink([n '.img'],[n '.hdr']);
            case '.nii'
                spm_unlink(SPM.xCon(k).Vcon.fname);
        end;
        [p n e v] = spm_fileparts(SPM.xCon(k).Vspm.fname);
        switch e,
            case '.img'
                spm_unlink([n '.img'],[n '.hdr']);
            case '.nii'
                spm_unlink(SPM.xCon(k).Vspm.fname);
        end;
    end;
    SPM.xCon = [];
end;

bayes_con=isfield(SPM,'PPM');
if bayes_con
    if ~isfield(SPM.PPM,'xCon')
        % Retrospectively label Bayesian contrasts as T's, if this info is missing
        for ii=1:length(SPM.xCon)
            SPM.PPM.xCon(ii).PSTAT='T';
        end
    end
end

for i = 1:length(job.consess)
    if isfield(job.consess{i},'tcon')
        name = job.consess{i}.tcon.name;
        if bayes_con
            STAT = 'P';
            SPM.PPM.xCon(end+1).PSTAT = 'T';
            SPM.xX.V=[];
        else
            STAT = 'T';
        end
        con  = job.consess{i}.tcon.convec(:)';
        sessrep = job.consess{i}.tcon.sessrep;
    elseif isfield(job.consess{i},'tconsess')
        job.consess{i}.tconsess = job.consess{i}.tconsess; % save some typing
        name = job.consess{i}.tconsess.name;
        if bayes_con
            STAT = 'P';
            SPM.PPM.xCon(end+1).PSTAT = 'T';
            SPM.xX.V=[];
        else
            STAT = 'T';
        end
        if isfield(job.consess{i}.tconsess.coltype,'colconds')
            ccond = job.consess{i}.tconsess.coltype.colconds;
            con = zeros(1,size(SPM.xX.X,2)); % overall contrast
            for cs = job.consess{i}.tconsess.sessions
                for k=1:numel(ccond)
                    if SPM.xBF.order < ccond(k).colbf
                        error(['Session-based contrast %d:\n'...
                            'Basis function order (%d) in design less ' ...
                            'than specified basis function number (%d).'],...
                            i, SPM.xBF.order, ccond(k).colbf);
                    end;
                    % Index into columns belonging to the specified
                    % condition
                    try
                        cind = ccond(k).colbf + ...
                            ccond(k).colmodord*SPM.xBF.order ...
                            *SPM.Sess(cs).U(ccond(k).colcond).P(ccond(k) ...
                            .colmod).i(ccond(k).colmodord+1);
                        con(SPM.Sess(cs).col(SPM.Sess(cs).Fc(ccond(k).colcond).i(cind))) ...
                            = ccond(k).conweight;
                    catch
                        error(['Session-based contrast %d:\n'...
                            'Column "Cond%d Mod%d Order%d" does not exist.'],...
                            i, ccond(k).colcond, ccond(k).colmod, ccond(k).colmodord);
                    end;
                end;
            end;
        else % convec on extra regressors
            con = zeros(1,size(SPM.xX.X,2)); % overall contrast
            for cs = job.consess{i}.tconsess.sessions
                nC = size(SPM.Sess(cs).C.C,2);
                if nC < numel(job.consess{i}.tconsess.coltype.colreg)
                    error(['Session-based contrast %d:\n'...
                        'Contrast vector for extra regressors too long.'],...
                        i);
                end;
                ccols = numel(SPM.Sess(cs).col)-(nC-1)+...
                    [0:numel(job.consess{i}.tconsess.coltype.colreg)-1];
                con(SPM.Sess(cs).col(ccols)) = job.consess{i}.tconsess.coltype.colreg;
            end;
        end;
        sessrep = 'none';
    else %fcon
        name = job.consess{i}.fcon.name;
        if bayes_con
            STAT = 'P';
            SPM.PPM.xCon(end+1).PSTAT = 'F';
            SPM.xX.V=[];
        else
            STAT = 'F';
        end
        try
            con  = cat(1,job.consess{i}.fcon.convec{:});
        catch
            error('Error concatenating F-contrast vectors. Sizes are:\n %s\n',... 
                   num2str(cellfun('length',job.consess{i}.fcon.convec)))
        end
        sessrep = job.consess{i}.fcon.sessrep;
    end

  
    if isfield(SPM,'Sess') && ~strcmp(sessrep,'none')
        % assume identical sessions, no check!
        nc = numel(SPM.Sess(1).U);
        nsessions=numel(SPM.Sess);
        rcon = zeros(size(con,1),nc);
        switch sessrep
            case 'repl',
                % within-session zero padding, replication over sessions
                cons{1}= zeros(size(con,1),size(SPM.xX.X,2));
                for sess=1:nsessions
                    sfirst=SPM.Sess(sess).col(1);
                    cons{1}(:,sfirst:sfirst+size(con,2)-1)=con;
                end
                names{1} = sprintf('%s - All Sessions', name);
            case 'sess',
                for k=1:numel(SPM.Sess)
                    cons{k} = [zeros(size(con,1),SPM.Sess(k).col(1)-1) con];
                    names{k} = sprintf('%s - Session %d', name, k);
                end;
            case 'both'
                for k=1:numel(SPM.Sess)
                    cons{k} = [zeros(size(con,1),SPM.Sess(k).col(1)-1) con];
                    names{k} = sprintf('%s - Session %d', name, k);
                end;
                if numel(SPM.Sess) > 1
                    % within-session zero padding, replication over sessions
                    cons{end+1}= zeros(size(con,1),size(SPM.xX.X,2));
                    for sess=1:nsessions
                        sfirst=SPM.Sess(sess).col(1);
                        cons{end}(:,sfirst:sfirst+size(con,2)-1)=con;
                    end
                    names{end+1} = sprintf('%s - All Sessions', name);
                end;
        end;
    else
        cons{1} = con;
        names{1} = name;
    end;

    % Loop over created contrasts
    %-------------------------------------------------------------------
    for k=1:numel(cons)

        % Basic checking of contrast
        %-------------------------------------------------------------------
        [c,I,emsg,imsg] = spm_conman('ParseCon',cons{k},SPM.xX.xKXs,STAT);
        if ~isempty(emsg)
            disp(emsg);
            error('Error in contrast specification');
        else
            disp(imsg);
        end;

        % Fill-in the contrast structure
        %-------------------------------------------------------------------
        if all(I)
            DxCon = spm_FcUtil('Set',names{k},STAT,'c',c,SPM.xX.xKXs);
        else
            DxCon = [];
        end

        % Append to SPM.xCon. SPM will automatically save any contrasts that
        % evaluate successfully.
        %-------------------------------------------------------------------
        if isempty(SPM.xCon)
            SPM.xCon = DxCon;
        elseif ~isempty(DxCon)
            SPM.xCon(end+1) = DxCon;
        end
        SPM = spm_contrasts(SPM,length(SPM.xCon));
    end
end;
% Change back directory
%-----------------------------------------------------------------------
fprintf('   Changing back to directory: %s\n', wd);
cd(wd); 
