
clear;
clc;

%% set paths
% set spm
warning('off');
% addpath(genpath('/Users/battal/Documents/MATLAB/spm12'));
% bspm fmri
% addpath(genpath('/Users/shahzad/Documents/MATLAB/bspmview'));
% add xjview
% addpath(genpath('/Users/battal/Documents/MATLAB/xjview'));

% add cpp repo
run ../lib/CPP_SPM/initCppSpm.m;

% get all the parameters needed
% opt = getOptionVisLocaliser();
opt = getOptionTacLocaliser();
% opt = getOptionAudLocaliser();

%% Run batches
reportBIDS(opt);
bidsCopyRawFolder(opt, 1);

% slice time correction
bidsSTC(opt);

% spatial preprocessing
bidsSpatialPrepro(opt);
%
% % Quality control
% % anatomicalQA(opt);
% % bidsResliceTpmToFunc(opt);
% % functionalQA(opt);
%

% % smoothing first level
funcFWHM = 6;
bidsSmoothing(funcFWHM, opt);
%
%
% subject level univariate
bidsFFX('specifyAndEstimate', opt, funcFWHM);
bidsFFX('contrasts', opt, funcFWHM);
%

%
% %visualise the results
bidsResults(opt, funcFWHM);
%
% % % % group level univariate
% conFWHM = 8;
% bidsRFX('smoothContrasts', opt,funcFWHM, conFWHM);
% bidsRFX('RFX', opt, funcFWHM, conFWHM);
% %
% % % WIP: group level results
% % % bidsResults(opt, FWHM);
% %
