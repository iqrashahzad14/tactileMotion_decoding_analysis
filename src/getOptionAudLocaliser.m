% (C) Copyright 2020 Remi Gau, Marco Barilari

function opt = getOptionAudLocaliser()
    %
    % returns a structure that contains the options chosen by the user to run
    % slice timing correction, pre-processing, subject and group level analysis.
    %
    % for more info see:
    % <https://cpp-bids-spm.readthedocs.io/en/latest/set_up.html#configuration-of-the-pipeline>
    % <https://cpp-bids-spm.readthedocs.io/en/latest/defaults.html#checkoptions>

 if nargin < 1
    opt = [];
  end

  % group of subjects to analyze
  opt.groups = {''};
  % suject to run in each group
  opt.subjects = {'003'};

  % Uncomment the lines below to run preprocessing
  % - don't use realign and unwarp
  opt.realign.useUnwarp = true;

  % we stay in native space (that of the T1)
  % - in "native" space: don't do normalization
  opt.space = 'MNI'; % 'individual', 'MNI'

  % task to analyze
  opt.taskName = 'auditoryLocalizer';

  %% set paths
  opt.dataDir = fullfile(fileparts(mfilename('fullpath')), ...
                           '..', '..', '..', 'raw');
  opt.derivativesDir = fullfile(opt.dataDir, '..', ...
                                  'derivatives', 'cpp_spm');

  % Suffix output directory for the saved jobs
  opt.jobsDir = fullfile( ...
                         opt.dataDir, '..', 'derivatives', ...
                         'cpp_spm', 'JOBS', opt.taskName);
                     
  % specify the model file that contains the contrasts to compute
    % univariate
    opt.model.file =  ...
        fullfile(fileparts(mfilename('fullpath')), '..', ...
                 'model', 'model-auditoryLocalizer_smdl.json');


  % to add the hrf temporal derivative = [1 0]
  % to add the hrf temporal and dispersion derivative = [1 1]
  % opt.model.hrfDerivatives = [0 0];

  %% Specify the result to compute
  opt.result.Steps(1) = returnDefaultResultsStructure();

  opt.result.Steps(1).Level = 'subject';

  opt.result.Steps(1).Contrasts(1).Name = 'motion';
  opt.result.Steps(1).Contrasts(1).MC =  'none';
  opt.result.Steps(1).Contrasts(1).p = 0.001;
  opt.result.Steps(1).Contrasts(1).k = 0;

  % For each contrats, you can adapt:
  %  - voxel level (p)
  %  - cluster (k) level threshold
  %  - type of multiple comparison (MC):
  %    - 'FWE' is the defaut
  %    - 'FDR'
  %    - 'none'
  %
  % not working for multiple contrasts
  opt.result.Steps(1).Contrasts(2).Name = 'motion_gt_static';
  opt.result.Steps(1).Contrasts(2).MC =  'none';
  opt.result.Steps(1).Contrasts(2).p = 0.001;
  opt.result.Steps(1).Contrasts(2).k = 0;
  %
  opt.result.Steps(1).Contrasts(3).Name = 'static_gt_motion';
  opt.result.Steps(1).Contrasts(3).MC =  'none';
  opt.result.Steps(1).Contrasts(3).p = 0.001;
  opt.result.Steps(1).Contrasts(3).k = 0;

  % Specify how you want your output (all the following are on false by default)
  opt.result.Steps(1).Output.png = true();

  opt.result.Steps(1).Output.csv = true();

  opt.result.Steps(1).Output.thresh_spm = true();

  opt.result.Steps(1).Output.binary = true();

  opt.result.Steps(1).Output.montage.do = true();
  opt.result.Steps(1).Output.montage.slices = -12:4:60; % in mm -8:3:15;
  % axial is default 'sagittal', 'coronal'
  opt.result.Steps(1).Output.montage.orientation = 'axial';

  % will use the MNI T1 template by default but the underlay image can be
  % changed.
  opt.result.Steps(1).Output.montage.background = ...
      fullfile(spm('dir'), 'canonical', 'avg152T1.nii,1');

  %   opt.result.Steps(1).Output.NIDM_results = true();

  % Options for slice time correction
  opt.sliceOrder = [0, 0.9051, 0.0603, 0.9655, 0.1206, 1.0258, 0.181, ...
                    1.0862, 0.2413, 1.1465, 0.3017, 1.2069, 0.362, ...
                    1.2672, 0.4224, 1.3275, 0.4827, 1.3879, 0.5431, ...
                    1.4482, 0.6034, 1.5086, 0.6638, 1.5689, 0.7241, ...
                    1.6293, 0.7844, 1.6896, 0.8448, 0, 0.9051, 0.0603, ...
                    0.9655, 0.1206, 1.0258, 0.181, 1.0862, 0.2413, ...
                    1.1465, 0.3017, 1.2069, 0.362, 1.2672, 0.4224, ...
                    1.3275, 0.4827, 1.3879, 0.5431, 1.4482, 0.6034, ...
                    1.5086, 0.6638, 1.5689, 0.7241, 1.6293, 0.7844, ...
                    1.6896, 0.8448];
  
  opt.sliceOrder = [];
  opt.STC_referenceSlice = [];

  % Options for normalize
  % Voxel dimensions for resampling at normalization of functional data or leave empty [ ].
  opt.funcVoxelDims = [2.6 2.6 2.6];

  opt.parallelize.do = false;
  opt.parallelize.nbWorkers = 3;
  opt.parallelize.killOnExit = true;

  %% DO NOT TOUCH
  opt = checkOptions(opt);
  saveOptions(opt);


end
