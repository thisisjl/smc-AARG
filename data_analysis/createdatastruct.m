function [ ds ] = createdatastruct( filename )
    
    fprintf('Analizing file: %s\n',filename);
    
    % read data
    fileID = fopen(filename);
    format = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';
    data = textscan(fileID,format,'delimiter', ',', 'Headerlines', 1);
    fclose(fileID);

    data = [data{1} data{2} data{3} data{4} data{5} data{6} data{7} ...
        data{8} data{9} data{10} data{11} data{12} data{13} data{14} data{15}];

    % time stamp values in seconds
    timestamps = data(:,1);

    % distance of the subject to the sound location
    distance_raw = data(:,2);
    distance_fil = data(:,3);

    % azimuth angle of the subject to the sound location
    azimuth_raw = data(:,4);
    azimuth_fil = data(:,5);

    % user latitude and longitude:
    latitude = data(:,6);
    longitude = data(:,7);
    latitude_raw = data(:,8);
    longitude_raw = data(:,9);

    % sound latitude and longitude:
    sound_lat = data(:,10);
    sound_lon = data(:,11);

    currentorientation = data(:,12);    % angle to the north of the device

    % trial information:
    trialstate = data(:,13);            % 0: idle 1: training 2: testing
    trialnumber = data(:,14);
    earconPlayed = data(:,15);


    %% prepare fields of data struct
    
    numberoftrials = max(unique(trialnumber));                             % compute number of trials

	% prepare data structure fields
    trial_duration = zeros(1,numberoftrials);
    sound_found = zeros(1,numberoftrials);
%     trial_start_idx = zeros(1,numberoftrials);
%     trial_end_idx = zeros(1,numberoftrials);
    
    timestamps_trial = {[]};
    distance_raw_trial = {[]};
    distance_fil_trial = {[]};
	azimuth_raw_trial = {[]};
	azimuth_fil_trial = {[]};
    
    latitude_trial = {[]}; 
    longitude_trial = {[]};
    latitude_raw_trial = {[]};
    longitude_raw_trial = {[]};

    sound_lat_trial = {[]};
    sound_lon_trial = {[]};
    
    %% for each trial
    for i = 1:numberoftrials                            
        % Did the subject found the sound?
        earconPlayed_trial = (0 < sum(earconPlayed(trialnumber == i)));

        sound_found(i) = earconPlayed_trial;

        if ~earconPlayed_trial
            fprintf('Trial %i/%i: subject did not find sound\n',i,numberoftrials);
        end

        % compute the time needed to find the sound
        timestamps_trial{i} = timestamps(trialnumber == i);               % get all the timestamps of trial i
        earconPlayed_trial = earconPlayed(trialnumber == i);           % get all the earcon values of trial i

        if earconPlayed_trial                                          % if sound was found,
            idx_found = find(earconPlayed_trial);                      % get data index of when
            idx_found = idx_found(1); 
        else                                                           % if sound was not found
            idx_found = length(timestamps_trial{i});                      % use end of trial (for now)
        end

        trial_start = timestamps_trial{i}(1);                             % get trial starting time
        trial_end = timestamps_trial{i}(end);                             % get trial ending time
        ts_sound_found = timestamps_trial{i}(idx_found);                  % get time at what sound was found
        
        trial_duration(i) = ts_sound_found - trial_start;              % compute duration of trial
        
        
        % get the data indexes of this trial
        trial_idx = find(trialnumber==i);                              % for all the samples of the trial
        trial_start_idx = trial_idx(1);                             % for the first sample
        trial_end_idx = trial_idx(end);                             % for the last sample
        
        
        distance_raw_trial{i} = distance_raw(trial_start_idx:trial_end_idx);
        distance_fil_trial{i} = distance_fil(trial_start_idx:trial_end_idx);
        azimuth_raw_trial{i} = azimuth_raw(trial_start_idx:trial_end_idx);
        azimuth_fil_trial{i} = azimuth_fil(trial_start_idx:trial_end_idx);
        
        latitude_trial{i} = latitude(trial_start_idx:trial_end_idx);
        longitude_trial{i} = longitude(trial_start_idx:trial_end_idx);
        latitude_raw_trial{i} = latitude_raw(trial_start_idx:trial_end_idx);
        longitude_raw_trial{i} = longitude_raw(trial_start_idx:trial_end_idx);

        sound_lat_trial{i} = sound_lat(trial_start_idx:trial_end_idx);
        sound_lon_trial{i} = sound_lon(trial_start_idx:trial_end_idx);
        
    end  

    %% check which trials are training testing
    trial_idx_train = unique(trialnumber(trialstate==1));
    trial_idx_train_found = find(sound_found(trial_idx_train).*trial_idx_train');
    
    trial_idx_test = unique(trialnumber(trialstate==2));
    trial_idx_test_found = find(sound_found(trial_idx_test).*trial_idx_test');
    
    %%
    %% create data struct ds
    if strfind(filename,'hrtf') model_name = 'hrtf'; else model_name = 'panning';end;

%     ds = struct('name',filename,'trial_duration',trial_duration,...
%         'trial_idx_train',trial_idx_train,'trial_idx_test',trial_idx_test,...
%         'model',model_name,'sound_found',sound_found,'numberoftrials',...
%         numberoftrials,'trial_idx_train_found',trial_idx_train_found,...
%         'trial_idx_test_found',trial_idx_test_found,...
%         'trial_duration_train_found',trial_duration(trial_idx_train_found),...
%         'trial_duration_test_found',trial_duration(trial_idx_test_found));
    
    ds = struct('name',filename,...
        'trial_duration',trial_duration,...
        'trial_idx_train',trial_idx_train,...
        'trial_idx_test',trial_idx_test,...
        'model',model_name,...
        'sound_found',sound_found,...
        'numberoftrials', numberoftrials,...
        'trial_idx_train_found',trial_idx_train_found,...
        'trial_idx_test_found',trial_idx_test_found,...
        'trial_duration_train_found',trial_duration(trial_idx_train_found),...
        'trial_duration_test_found',trial_duration(trial_idx_test_found),...
        'trial_start_idx',trial_start_idx,...
        'trial_end_idx',trial_end_idx,...
        'distance_raw_trial',{distance_raw_trial},...
        'distance_fil_trial',{distance_fil_trial},...
        'azimuth_raw_trial', {azimuth_raw_trial},...
        'azimuth_fil_trial',{azimuth_fil_trial},...
        'latitude_trial',{latitude_trial},...
        'longitude_trial',{longitude_trial},...
        'latitude_raw_trial',{latitude_raw_trial},...
        'longitude_raw_trial',{longitude_raw_trial},...
        'sound_lat_trial',{sound_lat_trial},...
        'sound_lon_trial',{sound_lon_trial});
    
end






