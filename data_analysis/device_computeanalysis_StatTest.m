%% Data analysis script
% this script compares the data files of the different 3d audio models.

% The data is contained in two different folders called hrtf_data
% and panning_data.

% The data file contains the following fields:
% timestamps, raw distance, filtered distance, raw azimuth, 
% filtered azimuth, Latitude, Longitude, RAW_LAT, RAW_LONG, Sound_LAT, 
% Sound_LONG, currentOrientation, trialState, trialNumber, earconPlayed.


%% Read data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
subjectnumber = {'000';'001';'002';'003';'004';'005';'006';'007';'008';...%
    '010';'011';'012';'013';'014';'015';'016';'017'};
datadir = {'hrtf_data','panning_data'};                             % define data directories
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

%% for each subject, create data summary

fileID = fopen('datasummary.txt','w');
fprintf(fileID,'subject\thrtf mean\tpanning mean\n');
for sbj = 1:2:length(ds)-1
%     subjectnumber{sbj};
%     ds(sbj).usefultrials_mean                                       % hrtf
%     ds(sbj+1).usefultrials_mean                                     % panning
%     pause;
%     sprintf('%s\t%s',ds(sbj).usefultrials_mean,ds(sbj+1).usefultrials_mean);
    
    formatSpec = '%s\t%f\t%f\n';
    fprintf(fileID,formatSpec,subjectnumber{ceil(sbj/2)},ds(sbj).usefultrials_mean,ds(sbj+1).usefultrials_mean);
    
end
fclose(fileID);

%%

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



%% Stastical analysis with cleaned data - QUANTITATIVE ANALYSES
% for sbj = 1:2:length(ds)
%     dataHRTF(ceil(sbj/2)) = ds(sbj).usefultrials_mean; 
%     dataPanning(ceil(sbj/2)) = ds(sbj+1).usefultrials_mean;
% end
for sbj = 1:2:length(ds)
    dataHRTFall{ceil(sbj/2)} = ds(sbj).usefultrials; 
    dataPanningall{ceil(sbj/2)} = ds(sbj+1).usefultrials;
end

for i = 1:length(dataHRTFall);
    dataHRTFwithOutliers(i) = mean(dataHRTFall{i});
    dataPanningwithOutliers(i) = mean(dataPanningall{i});
end

for i = 1:length(dataHRTFall);
    dataHRTF(i) = mean(dataHRTFall{i});
    dataPanning(i) = mean(dataPanningall{i});
end

meanHRTF = mean(dataHRTF);
meanPanning = mean(dataPanning);
mdnHRTF = median(dataHRTF);
mdnPanning = median(dataPanning);
stdHRTF = std(dataHRTF);
stdPanning = std(dataPanning);
% checking if data is normal distributed
% Histogram
hist(dataHRTF);
figure;
hist(dataPanning);
figure;
% q-q Plot
qqplot(dataHRTF);
figure;
qqplot(dataPanning)
figure;

boxplot(dataHRTF)%,'whisker', 1.5);
figure;
boxplot(dataPanning)%, 'whisker', 1.5);
% Shapiro-Wilk test
[h1, p1, w1]=swtest(dataHRTF);
[h2, p2, w2]=swtest(dataPanning);
% perform paired samples t-test
[ht_test,pt_test,ci,statst_test] = ttest(dataHRTF, dataPanning)

% perform Wilcoxen-signed rank test
[p,h,stats] = signrank(dataHRTF, dataPanning)

% another test
signtest(dataHRTF,dataPanning);
%%
for sbj = 1:2:length(ds)
    dataHRTFall{ceil(sbj/2)} = ds(sbj).usefultrials; 
    dataPanningall{ceil(sbj/2)} = ds(sbj+1).usefultrials;
end

qqplot(dataHRTFall);
figure;
qqplot(dataPanningall)
figure;

boxplot(dataHRTFall)%,'whisker', 1.5);
figure;
boxplot(dataPanningall)%, 'whisker', 1.5);

%% Stastical analysis with cleaned data - QUAlITATIVE ANALYSES


