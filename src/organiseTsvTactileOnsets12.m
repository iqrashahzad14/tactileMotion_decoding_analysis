clear all
% add bids repo
bidsPath = '/Users/shahzad/Documents/MATLAB/GitHubcodes/CPP_BIDS';
addpath(genpath(fullfile(bidsPath,'src')));
addpath(genpath(fullfile(bidsPath,'lib')));

% bidsPath = '/Users/shahzad/Downloads/CPP_BIDS';
% IMPORTANT: subtract 1 for tactileLocalizer1, 0.5 for tactileLocalizer2 these the are ISI
tsvFileName = 'sub-003_ses-001_task-tactileLocalizer2_run-002_events.tsv';
tsvFileFolder = '/Users/shahzad/Documents/MATLAB/TacMotionAnalysis2/raw/sub-003/ses-001/func';

% Create output file name
outputTag = '_touched.tsv';

% create output file name
outputFileName = strrep(tsvFileName, '.tsv', outputTag);
          
% read the tsv file
output = bids.util.tsvread(fullfile(tsvFileFolder,tsvFileName));

for i=1:length(output.onset)
    
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

IBI = [ 5.8691    5.5432    6.4765    6.6958    5.0225    6.5777    5.6404    6.0738    5.9374    6.5624 ...
    5.4567    5.2934    5.0717    6.1504  5.8641    6.9503    5.1053    6.7020    5.7358    0];
IBI=IBI'; 
ind=0;
indLastEvent=find(output.event==16);%if the last event is 16th
for j=3:length(output.onset)
    if output.event(j)==1 %if a new stim of a block
        ind=ind+1;
        output.onset(j)=output.onset(indLastEvent(ind))+1 + IBI(ind);   
    end
    if output.event(j)==2 %if 2nd stim of a block
        output.onset(j)=output.onset(j)-0.5; %subtract 1 for tactileLocalizer1, 0.5 for tactileLocalizer2 these the are ISI
    end
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

 
 
