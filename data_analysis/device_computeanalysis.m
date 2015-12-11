%% Data analysis script
% this script compares the data files of the different 3d audio models.

% The data is contained in two different folders called hrtf_data
% and panning_data.

% The data file contains the following fields:
% timestamps, raw distance, filtered distance, raw azimuth, 
% filtered azimuth, Latitude, Longitude, RAW_LAT, RAW_LONG, Sound_LAT, 
% Sound_LONG, currentOrientation, trialState, trialNumber, earconPlayed.


%% Read data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
subjectnumber = {'001';'002';'003';'004';'005';'006';'007';'008';...%
    '010';'012';'013';'014';'015';'016';'017'};
datadir = {'panning_data','hrtf_data'};                             % define data directories
ds = struct([]);                                                    % initalize data struct

for sbj = 1:length(subjectnumber)
    for dd = 1:length(datadir)

        files = dir(sprintf('%s/%s*.txt',char(datadir(dd)),subjectnumber{sbj}));

        for f = 1:size(files,1)
            filename = fullfile(char(datadir(dd)),files(f).name);
            ds = [ds createdatastruct(filename)];
        end
    end
end

%% for each model...

durs_hrtf_test  = [];                                           % initialize array for hrtf durations
durs_hrtf_train = [];
durs_pan_test   = [];                                           % initialize array for panning durations
durs_pan_train  = [];

for i = 1:size(ds,2)                                            % for each data structure
    switch ds(i).model                                          % see which model is it
        case 'hrtf'                                             % if it is hrtf,
            % Test trial:
            % discard trial if not sound found
            test_durations = ds(i).trial_duration(ds(i).trial_idx_test);   % all test trials
%             test_durations_found = test_durations(...
%                 ds(i).sound_found.*ds(i).trial_idx_test');                 % sound found trials
            
            durs_hrtf_test = [durs_hrtf_test ...                % add the duration of the testing trials
                test_durations];
            
            % Train trial:
            % discard trial if not sound found
            train_durations = ds(i).trial_duration(ds(i).trial_idx_train); % all train trials
%             train_durations_found = train_durations(...
%                 ds(i).sound_found.*ds(i).trial_idx_train');    % sound found trials
              
            durs_hrtf_train = [durs_hrtf_train...               % add the duration of the training trials
                train_durations];
        
        case 'panning'                                          % if it is panning
            % Test trial:
            % discard trial if not sound found
            test_durations = ds(i).trial_duration(ds(i).trial_idx_test);   % all test trials
%             test_durations_found = test_durations(...
%                 ds(i).sound_found.*ds(i).trial_idx_test');                 % sound found trials
          
            durs_pan_test = [durs_pan_test ...                  % add the duration of the testing trials
                ds(i).trial_duration(ds(i).trial_idx_test)];    % where the sound was found
            
            % Train trial:
            % discard trial if not sound found
%             train_durations = ds(i).trial_duration(ds(i).trial_idx_train); % all train trials
%             train_durations_found = train_durations(ds(i).sound_found);    % sound found trials
            
            durs_pan_train = [durs_pan_train...                 % add the duration of the training trials
                ds(i).trial_duration(ds(i).trial_idx_train)];
    end
end



%% compute T test

durs_hrtf_test  = [];                                           % initialize array for hrtf durations
durs_hrtf_train = [];
durs_pan_test   = [];                                           % initialize array for panning durations
durs_pan_train  = [];

for i = 1:size(ds,2)                                            % for each data structure
    switch ds(i).model                                          % see which model is it
        case 'hrtf'                                             % if it is hrtf,
            durs_hrtf_test = [durs_hrtf_test ...                % add the duration of the testing trials
                ds(i).trial_duration(ds(i).trial_idx_test)];
            
            durs_hrtf_train = [durs_hrtf_train...               % add the duration of the training trials
                ds(i).trial_duration(ds(i).trial_idx_train)];
        
        case 'panning'                                          % if it is panning
            durs_pan_test = [durs_pan_test ...                  % add the duration of the testing trials
                ds(i).trial_duration(ds(i).trial_idx_test)];
            durs_pan_train = [durs_pan_train...                 % add the duration of the training trials
                ds(i).trial_duration(ds(i).trial_idx_train)];
    end
end

% perform paired sample ttest
disp('perform paired sample ttest')
[h p] = ttest(durs_hrtf_test(1:18),durs_pan_test(1:18),'Alpha',0.05);
% h = 0 means that the two models do not differ
% if p > 0.05 the two gaussians are too overlapped.

% perform Two-sample F test for equal variance
disp('perform Two-sample F test for equal variance')
[h p ci stats] = vartest2(durs_hrtf_test(1:18),durs_pan_test(1:18));

% Wilcoxson sign to rank test
disp('Wilcoxson sign to rank test')
[p h] = signrank(durs_hrtf_test(1:18),durs_pan_test(1:18))

% Single sample Kolmogorov-Smirnov goodness-of-fit hypothesis test
disp('Single sample Kolmogorov-Smirnov goodness-of-fit hypothesis test')
[h p] = kstest(durs_hrtf_test(1:18))%,durs_pan_test(1:18));
[h p] = kstest(durs_pan_test(1:18))



%%
