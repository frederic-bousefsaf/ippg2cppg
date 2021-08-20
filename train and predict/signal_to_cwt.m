function [cwA] = signal_to_cwt(time, signal)

% COMPUTE SCALES
sc_min = -1;
sc_max = -1;
sc = 0.2:0.01:1000;
MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));
freqs = 1./(sc.*MorletFourierFactor);
for dummy=1:length(freqs)
    if (freqs(dummy)<0.6 && sc_max==-1)     % can be adjusted
        sc_max = sc(dummy);
        
    elseif (freqs(dummy)<8 && sc_min==-1)   % can be adjusted
        sc_min = sc(dummy);
    end
end
sc = [sc_min sc_max];


% RESAMPLE SIGNAL OVER 256 VALUES
time_interp = linspace(time(1), time(end), 256);
signal_interp = interp1(time, signal, time_interp);

% STANDARDIZE SIGNAL
signal_interp = (signal_interp - mean(signal_interp)) / std(signal_interp);

% COMPUTE CWT
fps = round(1/mean(diff(time_interp)));
cwA = cwtft({signal_interp,1/fps},'scales',{sc(1) 0.00555 ceil((sc(2)-sc(1))/0.00555) 'lin'},'wavelet','morl');
 
end