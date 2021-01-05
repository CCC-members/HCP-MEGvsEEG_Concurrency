function [F,Svv,PSD,Data_FC,Ntpoints,Nsegments] = cross_spectrum(Data,deltaf,Fs,Nw)
Ntpoints    = round(Fs/deltaf);
Nsegments   = floor(length(Data)/Ntpoints);
Nsens       = size(Data,1);

Data_FC     = zeros(Nsens,Ntpoints,2*Nw,Nsegments);
F           = 0:deltaf:((Ntpoints-1)*deltaf);
Nfreq       = length(F);
Svv         = zeros(Nsens,Nsens,Nfreq);
PSD         = zeros(Nsens,Nfreq);
e           = dpss(Ntpoints,Nw);
e           = reshape(e,[1,Ntpoints,2*Nw]);
Data        = Data(:,1:Ntpoints*Nsegments);
Data        = reshape(Data,Nsens,Ntpoints,Nsegments);
for seg = 1:Nsegments
    disp(strcat('-->> processing time segment: ', num2str(seg)));
    tmp                   = squeeze(Data(:,1:Ntpoints,seg));
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
% [val,idf1] = min(abs(F - 105));
% [val,idf2] = min(abs(F - 145));
% [val,idf]  = min(abs(F - 350));
% ampnorm    = mean(PSD(:,idf),2);
% ampnorm    = sqrt(ampnorm*ampnorm');
% ampnorm    = repmat(ampnorm,1,1,length(F));
% Svv        = Svv./ampnorm;