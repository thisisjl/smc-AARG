%% Questionnaire analysis script
% data is tab separated value (.tsv)

%% Read data:
filename = 'questionnaire_answers.tsv';
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

% for each engine
for i = 1:2

    % It was easy and intuitive to find the sounds
    col = 1;
    [counts, centers] = hist([page1(engine==i,col);page2(engine~=i,col)], 1:1:10);
    figure;bar(centers,counts)
    title(sprintf('%s: It was easy and intuitive to find the sounds',enginename{i}))

    % The sounds appeared to be bound to a physical location in the area:
    col = 2;
    [counts, centers] = hist([page1(engine==i,col);page2(engine~=i,col)], 1:1:10);
    figure;bar(centers,counts)
    title(sprintf('%s: The sounds appeared to be bound to a physical location in the area:',...
        enginename{i}))

    % There was a strong connection between my position and what I heard in the headphones
    col = 3;
    [counts, centers] = hist([page1(engine==i,col);page2(engine~=i,col)], 1:1:10);
    figure;bar(centers,counts)
    title(sprintf('%s: There was a strong connection between my position and what I heard in the headphones',...
        enginename{i}))

    % The soundscape was more inside my head than outside in the area
    col = 4;
    [counts, centers] = hist([page1(engine==i,col);page2(engine~=i,col)], 1:1:10);
    figure;bar(centers,counts)
    title(sprintf('%s: The soundscape was more inside my head than outside in the area',...
        enginename{i}))

    % It was difficult to tell if a sound was in front of or behind me
    col = 4;
    [counts, centers] = hist([page1(engine==i,col);page2(engine~=i,col)], 1:1:10);
    figure;bar(centers,counts)
    title(sprintf('%s: It was difficult to tell if a sound was in front of or behind me',...
        enginename{i}))
end