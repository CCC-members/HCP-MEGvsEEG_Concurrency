function eeg_meg_concurrency(protocol_path,paths,SubID)


paths.output_path = fullfile(paths.output_path,SubID);
mkdir(paths.output_path);
%% Human connectome MEG preprocessed file
preproced_data_path = fullfile(paths.data_path,SubID,'MEG','Restin','rmegpreproc','',strcat(SubID,'_MEG_5-Restin_rmegpreproc.mat'));

%% Parameters
method_label  = {'sSSBL' 'sSSBLparcelled' 'sSSBLlaplacian' 'sSSBL2Disotropic' 'sSSBL3Disotropic' 'sSSBLunwrapped' 'sSSBL++' 'eLORETA' 'LCMV'};
% sSSBL with priors of smoothness in 2D cartesian space of samples and band frequencies
% sSSBLparcelled with priors of smoothness in 3D cartesian space of samples, band frequencies and parcells
% sSSBL3Dfield with priors of rotational invariance of 3D source fields
% sSSBLunwrapped with priors of compensation for surface curvature
% sSSBLplus with all prior information

bands         = [0.1 4; 4.1 8; 8.1 15; 16.1 31; 32.1 40];
band_label    = {'delta' 'theta' 'alpha' 'beta' 'gamma'};

%% Prepare data for ECG/EEG concurrency evaluation
sim_data      = struct;
[sim_data]    = meeg_sim_structural(sim_data,preproced_data_path,protocol_path,SubID);
[sim_data]    = meeg_sim_functional(sim_data,preproced_data_path);
[sim_data]    = meeg_sim_landmark(sim_data,bands);

%% Concurrency evaluation
disp('-->> performing concurrency evaluation');
% outputs:
% J     - 1xlength(bands) cell array with MEG and EEG source activity vectors concatenated along the second dimension
% stat  - 1xlength(bands) cell array with MEG and EEG source statistic vectors concatenated along the second dimension
% indms - 1xlength(bands) cell array with MEG and EEG active indexes in concatenated in 1x2 cell array

%% sSSBL
disp('-->> Spectral SSBL');
ismethod  = 1;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 1; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J,stat,indms,T,data] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_sSSBL          = J;
stat_sSSBL       = stat;
indms_sSSBL      = indms;
T_sSSBL          = T;
data_sSSBL       = data;

%% sSSBLparcelled
disp('-->> Spectral SSBL parcelled');
ismethod  = 1;
isparcel  = 1; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 1; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J,stat,indms,T,data] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_sSSBLparcelled          = J;
stat_sSSBLparcelled       = stat;
indms_sSSBLparcelled      = indms;
T_sSSBLparcelled          = T;
data_sSSBLparcelled       = data;

%% sSSBLlaplacian
disp('-->> Spectral SSBL laplacian');
ismethod  = 1;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 1; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 1; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J,stat,indms,T,data] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_sSSBLlaplacian          = J;
stat_sSSBLlaplacian       = stat;
indms_sSSBLlaplacian      = indms;
T_sSSBLlaplacian          = T;
data_sSSBLlaplacian       = data;

%% sSSBL2Disotropy
disp('-->> Spectral 2Disotropy');
ismethod  = 1;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 2; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J,stat,indms,T,data] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_sSSBL2Disotropy          = J;
stat_sSSBL2Disotropy       = stat;
indms_sSSBL2Disotropy      = indms;
T_sSSBL2Disotropy          = T;
data_sSSBL2Disotropy       = data;

%% sSSBL3Disotropy
disp('-->> Spectral SSBL 3Disotropy');
ismethod  = 1;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 3; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J,stat,indms,T,data] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_sSSBL3Disotropy          = J;
stat_sSSBL3Disotropy       = stat;
indms_sSSBL3Disotropy      = indms;
T_sSSBL3Disotropy          = T;
data_sSSBL3Disotropy       = data;

%% sSSBLunwrapped
disp('-->> Spectral SSBL unwrapped');
ismethod  = 1;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 1; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)

% giri compensation
iscurv    = 1; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J_giri,stat_giri,indms_giri,T_giri,data_giri] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);

% sulci compensation
iscurv    = -1; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J_sulc,stat_sulc,indms_sulc,T_sulc,data_sulc] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);

J_sSSBLunwrapped          = {J_giri J_sulc};
stat_sSSBLunwrapped       = {stat_giri stat_sulc};
indms_sSSBLunwrapped      = {indms_giri indms_sulc};
T_sSSBLunwrapped          = {T_giri T_sulc};
data_sSSBLunwrapped       = {data_giri data_sulc};

%% sSSBL++
disp('-->> Spectral SSBL with all prior information');
ismethod  = 1;
isparcel  = 1; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 1; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 2; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)

% giri compensation
iscurv    = 1; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J_giri,stat_giri,indms_giri,T_giri,data_giri] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);

% sulci compensation
iscurv    = -1; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)
[J_sulc,stat_sulc,indms_sulc,T_sulc,data_sulc] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);

J_sSSBLpp          = {J_giri J_sulc};
stat_sSSBLpp       = {stat_giri stat_sulc};
indms_sSSBLpp      = {indms_giri indms_sulc};
T_sSSBLpp          = {T_giri T_sulc};
data_sSSBLpp       = {data_giri data_sulc};

%% eLORETA
disp('-->> Spectral eLORETA');
ismethod  = 2;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 1; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)

[J,stat,indms,T,data]        = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_eLORETA          = J;
stat_eLORETA       = stat;
indms_eLORETA      = indms;
T_eLORETA          = T;
data_eLORETA       = data;

%% LCMV
disp('-->> Spectral LCMV');
ismethod  = 3;
isparcel  = 0; % 0 (no smoothness) 1 (parcel smoothness)
isneigh   = 0; % 0 (no neighbor structure) 1 (Laplacian neighbor structure)
isfield   = 1; % 1 (projected Lead Field) 2 (3D Lead Field with 2D isotropic rotational invariance) 3 (3D Lead Field with 3D isotropic rotational invariance)
iscurv    = 0; % 0 (no compensation) 1 (giri curvature compensation) -1 (sulci curvature compensation)

[J,stat,indms,T,data]        = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv);
J_LCMV          = J;
stat_LCMV       = stat;
indms_LCMV      = indms;
T_LCMV          = T;
data_LCMV       = data;
%% Band filtered time series
restoredefaultpath
addpath(paths.common_functions);
addpath(paths.simulation_data);
addpath(paths.concurrency_evaluation);
[sim_data] = filt_tseries(sim_data,bands);
addpath(genpath(paths.brainstorm_path));
addpath(paths.fieldtrip_path);
addpath(genpath('TrafficToolBox'));
ft_defaults

%% Performance
%% sSSBL
[space_freq_sSSBL,time_freq_sSSBL]                         = performance_concurrency(paths,sim_data,J_sSSBL,T_sSSBL,bands,band_label,1,0,method_label{1});
figure_concurrency(paths,sim_data,data_sSSBL,J_sSSBL,space_freq_sSSBL,time_freq_sSSBL,band_label,method_label{1});
figure_blur(paths,sim_data,space_freq_sSSBL,band_label,method_label{1});

%% sSSBLparcelled
[space_freq_sSSBLparcelled,time_freq_sSSBLparcelled]       = performance_concurrency(paths,sim_data,J_sSSBLparcelled,T_sSSBLparcelled,bands,band_label,1,0,method_label{2});
figure_concurrency(paths,sim_data,data_sSSBLparcelled,J_sSSBLparcelled,space_freq_sSSBLparcelled,time_freq_sSSBLparcelled,band_label,method_label{2});
figure_blur(paths,sim_data,space_freq_sSSBLparcelled,band_label,method_label{2});

%% sSSBLlaplacian
[space_freq_sSSBLlaplacian,time_freq_sSSBLlaplacian]       = performance_concurrency(paths,sim_data,J_sSSBLlaplacian,T_sSSBLlaplacian,bands,band_label,1,0,method_label{3});
figure_concurrency(paths,sim_data,data_sSSBLlaplacian,J_sSSBLlaplacian,space_freq_sSSBLlaplacian,time_freq_sSSBLlaplacian,band_label,method_label{3});
figure_blur(paths,sim_data,space_freq_sSSBLlaplacian,band_label,method_label{3});

%% sSSBL2Disotropy
[space_freq_sSSBL2Disotropy,time_freq_sSSBL2Disotropy]     = performance_concurrency(paths,sim_data,J_sSSBL2Disotropy,T_sSSBL2Disotropy,bands,band_label,2,0,method_label{4});
figure_concurrency(paths,sim_data,data_sSSBL2Disotropy,J_sSSBL2Disotropy,space_freq_sSSBL2Disotropy,time_freq_sSSBL2Disotropy,band_label,method_label{4});
figure_blur(paths,sim_data,space_freq_sSSBL2Disotropy,band_label,method_label{4});

%% sSSBL3Disotropy
[space_freq_sSSBL3Disotropy,time_freq_sSSBL3Disotropy]     = performance_concurrency(paths,sim_data,J_sSSBL3Disotropy,T_sSSBL3Disotropy,bands,band_label,3,0,method_label{5});
figure_concurrency(paths,sim_data,data_sSSBL3Disotropy,J_sSSBL3Disotropy,space_freq_sSSBL3Disotropy,time_freq_sSSBL3Disotropy,band_label,method_label{5});
figure_blur(paths,sim_data,space_freq_sSSBL3Disotropy,band_label,method_label{5});

%% sSSBLunwrapped
[space_freq_sSSBLunwrapped,time_freq_sSSBLunwrapped]       = performance_concurrency(paths,sim_data,J_sSSBLunwrapped,T_sSSBLunwrapped,bands,band_label,1,1,method_label{6});
figure_concurrency(paths,sim_data,data_sSSBLunwrapped,J_sSSBLunwrapped,space_freq_sSSBLunwrapped,time_freq_sSSBLunwrapped,band_label,method_label{6});
figure_blur(paths,sim_data,space_freq_sSSBLunwrapped,band_label,method_label{6});

%% sSSBLpp
[space_freq_sSSBLpp,time_freq_sSSBLpp]                     = performance_concurrency(paths,sim_data,J_sSSBLpp,T_sSSBLpp,bands,band_label,2,1,method_label{7});
figure_concurrency(paths,sim_data,data_sSSBLpp,J_sSSBLpp,space_freq_sSSBLpp,time_freq_sSSBLpp,band_label,method_label{7});
figure_blur(paths,sim_data,space_freq_sSSBLpp,band_label,method_label{7});

%% eLORETA
[space_freq_eLORETA,time_freq_eLORETA]                     = performance_concurrency(paths,sim_data,J_eLORETA,T_eLORETA,bands,band_label,1,0,method_label{8});
figure_concurrency(paths,sim_data,data_eLORETA,J_eLORETA,space_freq_eLORETA,time_freq_eLORETA,band_label,method_label{8});
figure_blur(paths,sim_data,space_freq_eLORETA,band_label,method_label{8});

%% LCMV
[space_freq_LCMV,time_freq_LCMV]                           = performance_concurrency(paths,sim_data,J_LCMV,T_LCMV,bands,band_label,1,0,method_label{9});
figure_concurrency(paths,sim_data,data_LCMV,J_LCMV,space_freq_LCMV,time_freq_LCMV,band_label,method_label{9});
figure_blur(paths,sim_data,space_freq_LCMV,band_label,method_label{9});

end
