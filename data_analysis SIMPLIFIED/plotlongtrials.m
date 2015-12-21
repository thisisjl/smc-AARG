%% Read data - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
clear all;
% subjectnumber = {'000';'001';'002';'003';'004';'005';'006';'007';'008';...%
%     '010';'011';'012';'013';'014';'015';'016';'017'};
% datadir = {'hrtf_data','panning_data'};                             % define data directories
subjectnumber = {'008'};
datadir = {'hrtf_data'};                             % define data directories

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

%%
ds(1).usefultrials
ds(1).trial_idx_test_found
%%
sbj = 1;
trialnum = 3;
useidx = 1;
timestamps = ds(sbj).timestamps_trial{trialnum};
distance1 = ds(sbj).distance_raw_trial{trialnum};
distance2 = ds(sbj).distance_fil_trial{trialnum};


a = find(ds(sbj).earconarray_trial{trialnum});
earconat = timestamps(a(1))-timestamps(1);


figure;
plot(timestamps-timestamps(1),distance1);hold on
plot(timestamps-timestamps(1),distance2,'r')
plot([earconat earconat], [min(distance1) max(distance1)],'k')
title(sprintf('Distance plot. Subject %s. Trial %i. Duration: %f (s)',...
    subjectnumber{sbj},useidx,ds(sbj).usefultrials(useidx)))
xlabel('time (s)');
ylabel('distance (m)')
legend('raw','filtered')

figure;
azimuth1 = ds(sbj).azimuth_raw_trial{trialnum};
azimuth2 = ds(sbj).azimuth_fil_trial{trialnum};
plot(timestamps-timestamps(1),rad2deg(azimuth1));hold on
plot(timestamps-timestamps(1),rad2deg(azimuth2),'r')
title(sprintf('Azimuth plot. Subject %s. Trial %i. Duration: %f (s)',...
    subjectnumber{sbj},useidx,ds(sbj).usefultrials(useidx)))
xlabel('time (s)');
ylabel('azimuth (deg)')
legend('raw','filtered')

%% 
threshold = 200;

for sbj = 1:length(ds)
    fprintf('Deeper look: %s\n',ds(sbj).name)
    
    hrtfdata{ceil(sbj/2)} = ds(sbj).usefultrials;                                            % hrtf
    
    ds(sbj).trial_idx_test_found
    
    idx = find(hrtfdata{ceil(sbj/2)} > threshold);
    
    for i = 1:length(idx)
        val = hrtfdata{ceil(sbj/2)}(idx(i)); % duration value
        
        trialnum = ds(sbj).trial_idx_test_found(idx(i));
        
        timestamps = ds(sbj).timestamps_trial{trialnum};
        distance1 = ds(sbj).distance_raw_trial{trialnum};
        distance2 = ds(sbj).distance_fil_trial{trialnum};
        
        a = find(ds(sbj).earconarray_trial{trialnum});
        earconat = timestamps(a(1))-timestamps(1);
        
        
        figure;
        plot(timestamps-timestamps(1),distance1);hold on
        plot(timestamps-timestamps(1),distance2,'r')
        plot([earconat earconat], [min(distance1) max(distance1)],'k')
%         title(sprintf('Distance Trial %i: %f (s)',trialnum,val))
        title('Distance. Subject 000. Trial 2')
        legend('raw','filtered')
        
        figure;
        timestamps = ds(sbj).timestamps_trial{trialnum};
        azimuth1 = ds(sbj).azimuth_raw_trial{trialnum};
        azimuth2 = ds(sbj).azimuth_fil_trial{trialnum};
        plot(timestamps-timestamps(1),azimuth1);hold on
        plot(timestamps-timestamps(1),azimuth2,'r')
        plot([earconat earconat], [min(azimuth1) max(azimuth1)],'k')
        title(sprintf('Azimuth Trial %i: %f (s)',trialnum,val))
        legend('raw','filtered')
        
        
    end
end





% ds(sbj).timestamps_trial{find(idx(i))(ds(sbj).earconPlayed_trial{idx(i)})}





