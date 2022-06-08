% Load base parameters
load('SDWBA_TS_AZKABAN.mat')

kL = 2*pi*frequency/c*ActualLength;

n_iter = 1000;
% Set array of frequencies for run
freq_dist = [185:0.5:255]*10^3;

%% Set parameters values
mu = 2.4;
sigma = 0.27;
g_mean = 1.037;
g_sd = 0.005;
h_mean = 1.026;
h_sd = 0.005;
%% Set parmeter distributions
length_dist = random('lognormal',mu,sigma,1,n_iter)/1000; %m
g_dist = random('Normal',g_mean, g_sd, 1,n_iter);
h_dist = random('Normal',h_mean, h_sd, 1,n_iter);

% Set array of frequencies for run
freq_dist = 185:0.5:255;

% Setup orientation
orientation_mean = 20;
orientation_sd = 20;

% Prepare results arrays
TS_Simplified = zeros(size(freq_dist,2),n_iter);

%% looooop
for ind_iter = 1:n_iter
    for ind_freq = 1:size(freq_dist,2)
        g0 = g_dist(ind_iter);
        h0 = h_dist(ind_iter);
        length = length_dist(ind_iter);
        frequency = freq_dist(ind_freq)*10^3;


        kL = 2*pi*frequency/c*ActualLength;
        [sigma, TS] = AverageTSorientation(BSsigma, orientation_mean, orientation_sd);
        TS_Simplified(ind_freq,ind_iter) = Calculate_Simplified_TS_SDWBA(frequency,length); 
    end
end

save('SDWBA_AZKABAN_data.mat',TS_Simplified,freq_dist,g_dist,h_dist,length_dist)