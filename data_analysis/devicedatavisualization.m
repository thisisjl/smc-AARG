%% Data analysis script
% this script compares the data files of the different 3d audio models.

% The data is contained in two different folders called hrtf_data
% and panning_data.

% The data file contains the following fields:
% timestamps, raw distance, filtered distance, raw azimuth, 
% filtered azimuth, Latitude, Longitude, RAW_LAT, RAW_LONG, Sound_LAT, 
% Sound_LONG, currentOrientation, trialState, trialNumber, earconPlayed.


%% Read data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

datadir = {'panning_data','hrtf_data'}; % define data directories
ds = struct([]);                        % initalize data struct

for dd = 1:length(datadir)
    
    files = dir(sprintf('%s/*.txt',char(datadir(dd))));


    for f = 1:size(files,1)
        filename = fullfile(char(datadir(dd)),files(f).name);
        ds = [ds createdatastruct(filename)];
    end
end

%% Plot durations of each model
figure(1); hold on
figure(2); hold on
sbjs_hrtf = [];
sbjs_pan  = [];
for i = 1:size(ds,2)                                        % for each data structure
    switch ds(i).model                                      % see which model is it
        case 'hrtf'                                         % if it is hrtf,
            figure(1);
            plot(ds(i).trial_duration(ds(i).trial_idx_test),'*-');
            a = (strsplit(ds(i).name,'/'));a = a{2};a=a(1:3);
            sbjs_hrtf = [sbjs_hrtf(:,:);a];
        case 'panning'                                      % if it is panning
            figure(2);
            plot(ds(i).trial_duration(ds(i).trial_idx_test),'*-');
            a = (strsplit(ds(i).name,'/'));a = a{2};a=a(1:3);
            sbjs_pan = [sbjs_pan(:,:); a];
    end
end
figure(1);title('HRTF durations');legend(sbjs_hrtf);
set(gca,'XTick',[1 2 3 4],'XTickLabels',{'1','2','3','4'})
xlabel('Trials');ylabel('time (s)')

figure(2);title('Panning durations');legend(sbjs_pan);
set(gca,'XTick',[1 2 3 4],'XTickLabels',{'1','2','3','4'})
xlabel('Trials');ylabel('time (s)')


%% Compute durations of each model
disp('Computing durations of each model')

durs_hrtf_test  = [];                                       % initialize array for hrtf durations
durs_hrtf_train = [];
durs_pan_test   = [];                                       % initialize array for panning durations
durs_pan_train  = [];

for i = 1:size(ds,2)                                        % for each data structure
    switch ds(i).model                                      % see which model is it
        case 'hrtf'                                         % if it is hrtf,
            durs_hrtf_test = [durs_hrtf_test ...            % add the duration of the testing trials
                ds(i).trial_duration(ds(i).trial_idx_test)];
            
            durs_hrtf_train = [durs_hrtf_train...           % add the duration of the training trials
                ds(i).trial_duration(ds(i).trial_idx_train)];
        
        case 'panning'                                      % if it is panning
            durs_pan_test = [durs_pan_test ...              % add the duration of the testing trials
                ds(i).trial_duration(ds(i).trial_idx_test)];
            durs_pan_train = [durs_pan_train...             % add the duration of the training trials
                ds(i).trial_duration(ds(i).trial_idx_train)];
    end
end


% compute mean values:
disp('Compute mean values')
mean_hrtf_test = mean(durs_hrtf_test);
mean_hrtf_train = mean(durs_hrtf_train);
mean_pan_test = mean(durs_pan_test);
mean_pan_train = mean(durs_pan_train);

% compute variance values:
disp('Compute variance values')
var_hrtf_test = var(durs_hrtf_test);
var_hrtf_train = var(durs_hrtf_train);
var_pan_test = var(durs_pan_test);
var_pan_train = var(durs_pan_train);

%% Plotting
disp('Plotting')

% Plot all the values in boxplot
figure;
boxplot([durs_hrtf_test(1:length(ds)/2*3)' durs_pan_test(1:length(ds)/2*3)'],...
    'labels',{'hrtf','panning'});
title('duration comparison of first three trials')
xlabel('audio models')


% Plot mean
y = [mean_hrtf_train mean_hrtf_test; mean_pan_train mean_pan_test];
figure;h = bar(y);
set(gca,'XTickLabel',{'hrtf', 'panning'})
legend(h,{'train', 'test'});
title('mean duration for each model')
ylabel('time (s)')

% Plot variance
y = [var_hrtf_train var_hrtf_test; var_pan_train var_pan_test];
figure;h = bar(y);
set(gca,'XTickLabel',{'hrtf', 'panning'})
legend(h,{'train', 'test'});
title('duration variance values for each model')
ylabel('time (s)')



%%
% [counts bins] = hist(y);
% bar(y)
% text(bins,y,['y = ', num2str(counts(i))], 'VerticalAlignment', 'top', 'FontSize', 8)

% 	%% Plot duration
%     figure;
%     plot(1:numberoftestingtrials,trial_duration_tst,'-*')
%     set(gca,'Xtick',1:numberoftestingtrials)
%     xlabel('trial number')
%     ylabel('duration (seconds)')
%     axis([0.8 numberoftestingtrials+0.3 min(trial_duration_tst)-10 max(trial_duration_tst)+10])
%     title(filename)
%     %     title(sprintf('duration of each trial. mean value = %f',mean(trial_duration)))





 



% %% Plot duration
% plot(1:numberoftrials,trial_duration,'-*')
% set(gca,'Xtick',1:numberoftrials)
% xlabel('trial number')
% ylabel('duration (seconds)')
% axis([0.8 numberoftrials+0.3 min(trial_duration)-10 max(trial_duration)+10])
% title(sprintf('duration of each trial. mean value = %f',mean(trial_duration)))
% 
% %% Plot distance
% % (each background color represent a trial)
% for i = 1:numberoftrials
%     mycolors = {[0.88 0.88 0.88],[0.7 0.7 0.7]};
%     mycolor = [0 .5 .5];
%     timestamps_trial = timestamps(trialnumber == i);
%     distance_raw_trial = distance_raw(trialnumber == i);
%     
%     x = [timestamps_trial(1), timestamps_trial(end), timestamps_trial(end), timestamps_trial(1)];
%     y = [min(distance_raw_trial), min(distance_raw_trial), max(distance_raw_trial), ...
% max(distance_raw_trial)];
%     patch(x,y,mycolors{mod(i,2)+1},'EdgeColor',mycolors{mod(i,2)+1})
%     hold on
%     
% end
% % 
% plot(timestamps,distance_raw);
% plot(timestamps,distance_fil,'r');
% title('distance');
% xlabel('time (seconds)')
% ylabel('distance (m)')
% 
% 
% % plot if earconsound played or not
% plot(timestamps,earconPlayed,'k') 
% hold off
% 
% % 
% %% Plot raw distance vs filtered distance
% figure;
% plot(timestamps,distance_raw);hold on
% plot(timestamps,distance_fil,'r'); title('distance'); 
% plot(timestamps,earconPlayed);
% legend('raw','filtered');
% xlabel('time (seconds)')
% plot(timestamps,latitude)
% hold off
% % 
% %% Plot raw azimuth vs filtered azimuth
% figure;
% plot(timestamps,azimuth_raw);hold on
% plot(timestamps,azimuth_fil,'r'); title('azimuth'); 
% legend('raw','filtered');
% xlabel('time (seconds)')
% hold off
% % 
% % %% Plot
% % % scatter(latitude, longitude,'*');

