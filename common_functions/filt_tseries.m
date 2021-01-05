function [sim_data] = filt_tseries(sim_data,bands)
Data1     = sim_data.functional.data1.Data;
Fs1       = sim_data.functional.data1.Fs;
Nsegments = length(Data1);
Data_TS1 = cell(Nsegments,length(bands));
for band = 1:length(bands)
    disp(strcat('-->> processing band: ', num2str(band)));
    f1             = bands(band,1); %frequency band lower limit
    f2             = bands(band,2); %frequency band upper limit
    for seg = 1:Nsegments    
        tmp                = bandpass(Data1{seg}',[f1 f2],Fs1);
        Data_TS1{seg,band} = tmp';
    end
end
sim_data.functional.data1.Data_TS = Data_TS1;
end