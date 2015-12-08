%% get only found trials
% given two data files for the same subject and audio model, this script
% creates a new data file with only the trials where the subject found the
% sound.
%
% Usage:
% replace the subject number and run script
%
% The name of the new file will be the same as the first file but with
% "fixed_" prepended
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

% to do:
% - trial number can still be repeated
% ...

subjectnumber = '005';
files = dir(sprintf('%s*.txt',subjectnumber));

for f = 1:2                                                                % for each file
    filename = fullfile(files(f).name);

    fprintf('Analizing file: %s\n',filename);

    fileID = fopen(filename);
    format = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
    data = textscan(fileID,format,'delimiter', ',', 'Headerlines', 1);
    fclose(fileID);

    data = [data{1} data{2} data{3} data{4} data{5} data{6} data{7} ...
        data{8} data{9} data{10} data{11} data{12} data{13} data{14} data{15}];

    % trial information:
    trialstate = data(:,13);            % 0: idle 1: training 2: testing
    trialnumber = data(:,14);
    earconPlayed = data(:,15);


    %% for each trial
    % compute duration
    numberoftrials = max(unique(trialnumber));

    trial_duration = zeros(1,numberoftrials);

    for i = 1:numberoftrials
        earconPlayed_trial = (0 < sum(earconPlayed(trialnumber == i)));    % Did the subject found the sound?
        
        if ~earconPlayed_trial                                                          % sound not found
            fprintf('Trial %i/%i: subject did not find sound\n',i,numberoftrials);
        else                                                                            % sound found
            fprintf('Trial %i/%i: subject found sound copying it\n',i,numberoftrials);
            newdata{f,i} = data(trialnumber == i,:);
        end
    end  

end

%% write good trials to file
disp('Writing file');

fileID = fopen(sprintf('fixed_%s',files(1).name),'w');
formatSpec = '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n';
fprintf(fileID,'timestamps, raw distance, filtered distance, raw azimuth,filtered azimuth, Latitude, Longitude, RAW_LAT, RAW_LONG, Sound_LAT, Sound_LONG, currentOrientation, trialState, trialNumber, earconPlayed\n');
for kk = 1:size(newdata,1)
    for qq = 1:size(newdata,2)
        datatowrite = newdata{kk,qq};
        
        if ~isempty(datatowrite)
            for ww = 1:length(datatowrite)
                fprintf(fileID,formatSpec,datatowrite(ww,:));
            end
        end
    end
end
fclose(fileID);