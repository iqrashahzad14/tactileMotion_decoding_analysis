clear all
% add bids repo
bidsPath = '/Users/shahzad/Documents/MATLAB/GitHubcodes/CPP_BIDS';
addpath(genpath(fullfile(bidsPath,'src')));
addpath(genpath(fullfile(bidsPath,'lib')));

% bidsPath = '/Users/shahzad/Downloads/CPP_BIDS';
% IMPORTANT: subtract 1 for tactileLocalizer1, 0.5 for tactileLocalizer2, and also 3, 4, 5---- these the are ISI
tsvFileName = 'sub-001_ses-001_task-mainExperiment1_run-001_events.tsv';
tsvFileFolder = '/Users/shahzad/Documents/MATLAB/TacMotionAnalysis2/raw/sub-001/ses-001/func';

% Create output file name
outputTag = '_touched.tsv';

% create output file name
outputFileName = strrep(tsvFileName, '.tsv', outputTag);
          
% read the tsv file
output = bids.util.tsvread(fullfile(tsvFileFolder,tsvFileName));

for i=1:length(output.onset)
    if strcmp(output.modality_type(i),'tactile')==1
        if strcmp(output.trial_type(i),'response')==0 && mod(output.event(i),2)~=0 && ~isnan(output.event(i+1))%if odd &if next event is not NaN
            output.onset(i)=output.onset(i)+output.duration(i)+output.duration(i+1);
        elseif strcmp(output.trial_type(i),'response')==0 && mod(output.event(i),2)~=0 && isnan(output.event(i+1))%if odd & if next event is NaN
            output.onset(i)=output.onset(i)+output.duration(i)+output.duration(i+2);
        elseif strcmp(output.trial_type(i),'response')==0 && mod(output.event(i),2)==0 %if even
            output.onset(i)= output.onset(i)+output.duration(i)+1;
        end

        if strcmp(output.trial_type(i),'response')==0
            output.duration(i)=1.00;
        end
    end
end

% new IBI = IBI + 0.5 for tactile stimulation, so make an account of the
% new IBIs
% IBI =[5.78,5.3419,6.8,6.5483,5.4044,5.4333,5.7721,0]';

for k=1:length(output.onset)
    output.trial_type(k)=strcat(output.modality_type(k), '_', output.trial_type(k));
end

% convert to tsv structure
output = convertStruct(output);

% save as tsv
bids.util.tsvwrite(fullfile(tsvFileFolder,outputFileName), output);



function structure = convertStruct(structure)
    % changes the structure
    %
    % from struct.field(i,1) to struct(i,1).field(1)

    fieldsList = fieldnames(structure);
    tmp = struct();

    for iField = 1:numel(fieldsList)
        for i = 1:numel(structure.(fieldsList{iField}))
            tmp(i, 1).(fieldsList{iField}) =  structure.(fieldsList{iField})(i, 1);
        end
    end

    structure = tmp;

end

 
 
