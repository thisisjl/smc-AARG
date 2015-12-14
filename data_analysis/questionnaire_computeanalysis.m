%% Questionnaire analysis script
% data is tab separated value (.tsv)
clc
%% Read data:
filename = 'FINAL DATA/FINAL_qualitative_Data.tsv';
fprintf('Analizing file: %s\n',filename);

fileID = fopen(filename);
format = '%s%f%s%s%s%s%s%f%f%f%f%f%f%f%f%f%f%s%f%s%s%s%s%s%s%f%f%f%s%s%s%s%f';
data = textscan(fileID,format,'delimiter', '\t', 'Headerlines', 1);
fclose(fileID);

% get numerical data for each page
page1 = [data{8} data{9} data{10} data{11} data{12}];
page2 = [data{13} data{14} data{15} data{16} data{17}];
engine = data{33};                                      % engine: 1 is hrtf, 2 is panning

% define engine names
enginename = {'hrtf','panning'};

%% questions data: HRTF vs PANNING
% It was easy and intuitive to find the sounds
col = 1;
q1_hrtf = [page1(engine==1,col);page2(engine~=1,col)];
q1_pann = [page1(engine==2,col);page2(engine~=2,col)];

% The sounds appeared to be bound to a physical location in the area:
col = 2;
q2_hrtf = [page1(engine==1,col);page2(engine~=1,col)];
q2_pann = [page1(engine==2,col);page2(engine~=2,col)];

% There was a strong connection between my position and what I heard in the headphones
col = 3;
q3_hrtf = [page1(engine==1,col);page2(engine~=1,col)];
q3_pann = [page1(engine==2,col);page2(engine~=2,col)];

% The soundscape was more inside my head than outside in the area
col = 4;
q4_hrtf = [page1(engine==1,col);page2(engine~=1,col)];
q4_pann = [page1(engine==2,col);page2(engine~=2,col)];

% It was difficult to tell if a sound was in front of or behind me
col = 5;
q5_hrtf = [page1(engine==1,col);page2(engine~=1,col)];
q5_pann = [page1(engine==2,col);page2(engine~=2,col)];


% sum answers
qa_hrtf = q1_hrtf + q2_hrtf + q3_hrtf + (10 - q4_hrtf);
qa_pann = q1_pann + q2_pann + q3_pann + (10 - q4_pann);

q_hrtf = {q1_hrtf,q2_hrtf,q3_hrtf,q4_hrtf,q5_hrtf};
q_pann = {q1_pann,q2_pann,q3_pann,q4_pann,q5_pann};

qnw_hrtf = zeros(size(q1_hrtf));
qnw_pann = zeros(size(q1_hrtf));

for i = 1:length(q_hrtf)
    idx_hrtf = find(5<q_hrtf{i});
    
    qnw_hrtf(idx_hrtf) = qnw_hrtf(idx_hrtf) + ...
        q_hrtf{i}(idx_hrtf);
    
    idx_pann = find(q_pann{i}>=5);
    qnw_pann(idx_pann) = qnw_pann(idx_pann) + ...
        q_pann{i}(idx_pann);
end

%% Rest of the data
% Age
age = data{2};

% Gender
gender = strcmp(data{3},'Male'); % 0 is female, 1 is male

% vision impairment
visim = strcmp(data{5},'Yes');  % 0 is no, 1 is yes

% corrected with lenses
lenses = strcmp(data{6},'Yes');  % 0 is no, 1 is yes

% musical training
musictrn = strcmp(data{18},'Yes');

% years musical training
musictrn_years = data{19};

% Did you have any experience with 3-D sound before?
exp3D = data{20};

% Did you have any experience with audio navigation before?
expnav = data{22};

% Are you comfortable with wearing headphones?   
comfhead = data{24};

% 11. The sound of the surroundings (trafic noise etc.) was a confusing factor
confusing = data{26};

% 12. The sound cues were accurate and easy to interpret
cues = data{27};

% 13. The sound source was pleasant
pleasant = data{28};

%% Stastical analysis - QUALITATIVE ANALYSIS
a = qa_hrtf;
b = qa_pann;

% compute mean
disp('---- mean ----')
meanHRTF = mean(a)
meanPanning = mean(b)

% compute median
disp('---- median ----')
mdnHRTF = median(a)
mdnPanning = median(b)

% compute std
disp('---- std ----')
stdHRTF = std(a)
stdPanning = std(b)

% q-q Plot
disp('---- q plot ----')
figure;qqplot(a);
figure;qqplot(b);

% Shapiro-Wilk test. Test for normality
disp('---- Shapiro-Wilk test a ----')
[h1, p1, w1] = swtest(a)
disp('---- Shapiro-Wilk test b ----')
[h2, p2, w2] = swtest(b)

% perform paired samples t-test
disp('---- perform paired samples t-test ----')
[ht_test,pt_test,ci,statst_test] = ttest(a, b)

% perform Wilcoxen-signed rank test
disp('---- perform Wilcoxen-signed rank test ----')
[p,h,stats] = signrank(a, b)

%%