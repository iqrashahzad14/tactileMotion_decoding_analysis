clear all
% add bids repo
bidsPath = '/Users/shahzad/Documents/MATLAB/GitHubcodes/CPP_BIDS';
addpath(genpath(fullfile(bidsPath,'src')));
addpath(genpath(fullfile(bidsPath,'lib')));

% bidsPath = '/Users/shahzad/Downloads/CPP_BIDS';
% IMPORTANT: subtract 1 for tactileLocalizer1, 0.5 for tactileLocalizer2, and also 3, 4, 5---- these the are ISI
tsvFileName = 'sub-002_ses-001_task-tactileLocalizer3_run-002_events.tsv';
tsvFileFolder = '/Users/shahzad/Documents/MATLAB/TacMotionAnalysis2/raw/sub-002/ses-001/func';

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

IBI =[6.61741298925362,6.17652181394254,6.14350128634047,6.85314831226457,6.03386544676654,6.77164999314598,...
            5.57782848962517,6.44004326538653,5.66560658814285,5.09679190628406,5.49499765524879,6.23808027848395,...
            5.91395987441519,5.18351942969991,6.53556038749900,6.05466707416818,6.55700457725286,6.64264651241250,...
            6.45885658622143,5.78540412044273,5.74171512737085,5.43832969788185,5.52081478760945,6.57809360976607,...
            6.52829862401985,6.58805550027372,6.23110605541872,6.16989539098545,5.44799269786238,6.48792376255606,...
            6.47851569674723, 0];
IBI=IBI'; 
ind=0;
indLastEvent=find(output.event==12);%if the last event is 12th
for j=3:length(output.onset)
    if output.event(j)==1 %if a new stim of a block
        ind=ind+1;
        output.onset(j)=output.onset(indLastEvent(ind))+1 + IBI(ind);   
    end
    if output.event(j)==2 %if 2nd stim of a block
        output.onset(j)=output.onset(j)-0.5; %subtract 1 for tactileLocalizer1, 0.5 for tactileLocalizer2, and also 3, 4, 5---- these the are ISI
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

 
 
