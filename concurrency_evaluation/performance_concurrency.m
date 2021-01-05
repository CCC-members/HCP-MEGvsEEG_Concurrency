function [space_freq,time_freq] = performance_concurrency(paths,sim_data,J,T,bands,band_label,isfield,iscurv,method_label)
%% Parameters
surface              = sim_data.structural.surface;
L                    = sim_data.structural.L_data2;
ind                  = [1:length(L)]';
Vertices             = surface.Vertices;
Faces                = surface.Faces;
Ngen                 = length(ind);
Nbands               = length(bands);
emd                  = cell(8,Nbands);
emd{2,1}             = 'abs_emd';
emd{3,1}             = 'rel_emd_11';
emd{4,1}             = 'rel_emd_12';
emd{5,1}             = 'rel_emd_22';
emd{6,1}             = 'rel_emd_1';
emd{7,1}             = 'rel_emd_2';
emd{8,1}             = 'rel_emd_geom';
emd(1,2:(Nbands+1))  = band_label;
stremd               = sim_data.structural.stremd;
for band = 1:Nbands
    % checking for giri and sulci information
    if iscurv == 0 %no sulci and giri solutions
        J1(:,band)   = J{band}(:,1);
        J2(:,band)   = J{band}(:,2);
    else %averaging sulci and giri solutions
        J1(:,band)   = (J{1}{band}(:,1) + J{2}{band}(:,1))/2;
        J2(:,band)   = (J{1}{band}(:,2) + J{2}{band}(:,2))/2;
    end
end
J1                   = J1(ind,:);
J2                   = J2(ind,:);

%% Space-Frequency fluctuations of power amplitude
% Relative Earth Movers' Distance coeffcients
J1emd     = J1./repmat(sum(J1,1),Ngen,1);
J2emd     = J2./repmat(sum(J2,1),Ngen,1);
rel_emd11 = 0;
rel_emd12 = 0;
rel_emd22 = 0;

for band = 1:Nbands
    [emd_val(band)]        = earthMoversADMM(Vertices,Faces,J1emd(:,band),J2emd(:,band),stremd);
    [rel_emd1(band)]       = earthMoversADMM(Vertices,Faces,J1emd(:,band),zeros(length(J1emd),1),stremd);
    [rel_emd2(band)]       = earthMoversADMM(Vertices,Faces,J2emd(:,band),zeros(length(J2emd),1),stremd);
    if band > 1
        rel_emd11          = rel_emd11 + earthMoversADMM(Vertices,Faces,J1emd(:,band-1),J1emd(:,band),stremd);
        rel_emd12          = rel_emd12 + earthMoversADMM(Vertices,Faces,J1emd(:,band-1),J2emd(:,band),stremd);
        rel_emd22          = rel_emd22 + earthMoversADMM(Vertices,Faces,J2emd(:,band-1),J2emd(:,band),stremd);
    end
end
rel_emd11 = rel_emd11/(Nbands-1);
rel_emd12 = rel_emd12/(Nbands-1);
rel_emd22 = rel_emd22/(Nbands-1);

% Earth Movers' Distance
for band = 1:Nbands
    emd{2,band+1}    = emd_val(band);
    emd{3,band+1}    = emd_val(band)/rel_emd11;
    emd{4,band+1}    = emd_val(band)/rel_emd12;
    emd{5,band+1}    = emd_val(band)/rel_emd22;
    emd{6,band+1}    = emd_val(band)/rel_emd1(band);
    emd{7,band+1}    = emd_val(band)/rel_emd2(band);
    emd{8,band+1}    = sqrt(emd_val(band)^2/(rel_emd1(band)*rel_emd2(band)));
end

% spatial correlation
ind1                 = (1:Nbands);
ind2                 = (Nbands + 1):(2*Nbands);
J1J2                 = [J1 J2];
[P,p]                = corr(J1J2,'Type','Spearman');
P                    = P(ind1,ind2);
p                    = p(ind1,ind2);
cor                  = diag(P);
pvc                  = diag(p);
[P,p]                = partialcorr(J1J2,'Type','Spearman');
P                    = P(ind1,ind2);
p                    = p(ind1,ind2);
pcr                  = diag(P);
pvp                  = diag(p);

% blur
[blur]               = blur_transfer(sim_data,J,T,bands,ind,isfield,iscurv);

% Saving measures
space_freq.emd       = emd;
space_freq.blur      = blur;
space_freq.cor       = cor;
space_freq.pvc       = pvc;
space_freq.pcr       = pcr;
space_freq.pvp       = pvp;
space_freq.J1        = J1;
space_freq.J2        = J2;
file_name = strcat(method_label,' space_freq','.mat');
save(fullfile(paths.output_path,file_name),'space_freq');
%% Time-freqeuncy fluctuations of power amplitude
if iscurv == 0 %no sulci and giri solutions
    % Power Samples
    [J1,J2]              = power_samples(sim_data,J,T,bands,ind,isfield);
else %averaging sulci and giri solutions
    Tgiri                = T{1};
    Tsulc                = T{2};
    Jgiri                = J{1};
    Jsulc                = J{2};
    % Power Samples
    [J1giri,J2giri]      = power_samples(sim_data,Jgiri,Tgiri,bands,ind,isfield);
    [J1sulc,J2sulc]      = power_samples(sim_data,Jsulc,Tsulc,bands,ind,isfield);
    J1                   = (J1giri + J1sulc)/2;
    J2                   = (J2giri + J2sulc)/2;
end
% correlation and partial correlation maps
[cor,pvc,pcr,pvp]    = corr_map(Vertices,Faces,J1,J2,Ngen,bands);

%% Saving measures
time_freq.cor = cor;
time_freq.pvc = pvc;
time_freq.pcr = pcr;
time_freq.pvp = pvp;
% time_freq.J1  = J1;
% time_freq.J2  = J2;
file_name = strcat(method_label,' time_freq','.mat');
save(fullfile(paths.output_path,file_name),'time_freq');
end
