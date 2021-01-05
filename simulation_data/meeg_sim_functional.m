function [sim_data] = meeg_sim_functional(sim_data,preproced_data_path)
%% Loading data1
preproced_data = load(preproced_data_path);
%% data1
disp('-->> Creating data1 cross-spectrum');
Fs          = preproced_data.data.fsample;
Ntpoints    = size(preproced_data.data.trial{1,1},2);
deltaf      = Fs/Ntpoints;
Nw          = 3;
Nsegments   = length(preproced_data.data.trial);
Nsens       = length(preproced_data.data.label);
Data_FC     = zeros(Nsens,Ntpoints,2*Nw,Nsegments);
F           = 0:deltaf:((Ntpoints-1)*deltaf);
Nfreq       = length(F);
Svv         = zeros(Nsens,Nsens,Nfreq);
PSD         = zeros(Nsens,Nfreq);
e           = dpss(Ntpoints,Nw);
e           = reshape(e,[1,Ntpoints,2*Nw]);
for seg = 1:Nsegments
    disp(strcat('-->> processing time segment: ', num2str(seg)));
    tmp                   = preproced_data.data.trial{1,seg};
    tmp                   = repmat(tmp,[1,1,2*Nw]).*repmat(e,[Nsens,1,1]);
    tmp_FC                = fft(tmp,[],2);
    Data_FC(:,:,:,seg)    = tmp_FC;
    for freq = 1:Nfreq
        Svv(:,:,freq)     = Svv(:,:,freq) + squeeze(tmp_FC(:,freq,:))*squeeze(tmp_FC(:,freq,:))';
        PSD(:,freq)       = abs(diag(Svv(:,:,freq)));
    end
end
Nsegments  = Nsegments*2*Nw;
Svv        = Svv/Nsegments;

%% Saving data1
sim_data.functional.data1.F            = F;
sim_data.functional.data1.Fs           = Fs;
sim_data.functional.data1.Svv          = Svv;
sim_data.functional.data1.PSD          = PSD;
sim_data.functional.data1.Data_FC      = Data_FC;
sim_data.functional.data1.Data         = preproced_data.data.trial;
sim_data.functional.data1.deltaf       = deltaf;
sim_data.functional.data1.Ntpoints     = Ntpoints;
sim_data.functional.data1.Nsegments    = Nsegments;

%% Saving data2
sim_data.functional.data2.F            = F;
sim_data.functional.data2.Fs           = Fs;
sim_data.functional.data2.deltaf       = deltaf;
sim_data.functional.data2.Ntpoints     = Ntpoints;
sim_data.functional.data2.Nsegments    = Nsegments;
end