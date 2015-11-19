%% Head shadow model from brown and duda 1998
%% AN EFFICIENT HRTF MODEL FOR 3-D SOUND

%% read soundfile
clear;
buffer=audioread('piano.wav'); % change to whatever sound
fs=44100;
sound(buffer, fs); %for testing
bufferl=buffer(:,1)'; % this is just in case of a stereofile
l=length(bufferl);
%% all the variables

beta=2*340/0.0875 %0.0875m (8.75 cm) is the standard head radius,
t=1/fs;
tbeta=(t*beta);
theta=-pi;
figure; 
for theta= -pi/2:pi/18:pi/2 % change the angle theta in between -90 and 90

% simpel alpha with a spherical head asumed
% -PI/2 TO PI/2 = LEFT TO RIGHT
% alpha_l=1-sin(theta);
% alpha_r=1+sin(theta);
amin=0.1;
thetamin=2.6180;
%theta=[0:0.1:2*pi];
%complex model with a oval head asumed doesn't sem to work beter... need
%test
% HERE THETA=0 MEANS LEFT EAR!!! 0 TO PI = LEFT TO RIGHT
 alpha_l=(1+(amin/2))+(1-(amin/2))*cos((theta/thetamin)*pi)
 alpha_r=(1+(amin/2))+(1-(amin/2))*-cos((theta/thetamin)*pi)    


%plot(theta, alpha_l); hold on;
%plot(theta, alpha_r);

%the coificiants 
a0=2+tbeta;% a0 and a1 is unidndependend from theta and thus the same for both ears 
a1=-2+tbeta;
b0_l=2*alpha_l+tbeta; %b0 and b1 is dependend and thus different
b1_l=-2*alpha_l+tbeta;
b0_r=2*alpha_r+tbeta;
b1_r=-2*alpha_r+tbeta;
   
% plot the filters

[h,w] = freqz([b0_l,b1_l], [a0,a1]);
figure(1);plot((abs(w)),20*log10(h));hold on
[h,w] = freqz([b0_r,b1_r], [a0,a1]);
figure(2);plot((abs(w)),20*log10(h));hold on
%end


yl=0; %this need to be defined because matlab not accept recursion
yr=0; %this need to be defined because matlab not accept recursion

% implementation with the matlab filter function
y2l=filter([b0_l,b1_l], [a0,a1],bufferl);
y2r=filter([b0_r,b1_r], [a0,a1],bufferl);

% implemented with the formular
for i=2:l
yl(i)=((b0_l*bufferl(i))+(b1_l*bufferl(i-1)))-(a1*yl(i-1))*(1/a0);
yr(i)=((b0_r*bufferl(i))+(b1_r*bufferl(i-1)))-(a1*yr(i-1))*(1/a0);
end

% add the files
ytotal=[y2l;y2r];
% normalization
maxval=max(max(ytotal,[],2));
ynorm=ytotal/maxval;
% test
sound(ynorm,fs);
pause;
end
%sound(yl,fs);
%sound(yr,fs);