
restoredefaultpath;
clear all;
close all;
clc 
tic

%%
disp('-->> Starting process');
disp("=====================================================================");

addpath('app');
app_properties = jsondecode(fileread(strcat('app_properties.json')));

%% Printing data information
app_properties = jsondecode(fileread(strcat('app_properties.json')));
disp(strcat("-->> Name:",app_properties.generals.name));
disp(strcat("-->> Version:",app_properties.generals.version));
disp(strcat("-->> Version date:",app_properties.generals.version_date));
disp("=====================================================================");

%%
paths                           = struct;
paths.fieldtrip_path            = app_properties.fieldtrip.base_path;
paths.brainstorm_path           = app_properties.brainstorm.base_path;
paths.protocols_path            = app_properties.bst_protocols.base_path;
paths.data_path                 = app_properties.preprocessed_data.base_path;
paths.output_path               = app_properties.output_path.base_path;
paths.common_functions          = 'common_functions';
paths.functions                 = 'functions';
paths.simulation_data           = 'simulation_data';
paths.concurrency_evaluation    = 'concurrency_evaluation';
paths.tools                     = 'tools';

addpath(paths.common_functions);
addpath(paths.functions);
addpath(paths.simulation_data);
addpath(genpath(paths.tools));
addpath(paths.concurrency_evaluation);
addpath(genpath(paths.brainstorm_path));
addpath(genpath('TrafficToolBox'));

%% checking paths
if(~isfolder(paths.fieldtrip_path))
   return; 
end
if(~isfolder(paths.brainstorm_path))
   return; 
end
if(~isfolder(paths.protocols_path))
   return; 
end
if(~isfolder(paths.data_path))
   return; 
end
if(~isfolder(paths.output_path))
   mkdir(paths.output_path); 
end
addpath(paths.fieldtrip_path);

%% initializing fieltrip default properties
ft_defaults

%% Getting subjects for analysis
protocols = dir(paths.protocols_path);
if(isequal(app_properties.bst_protocols.protocol_name,"none") || isempty(app_properties.bst_protocols.protocol_name) )    
    protocols(ismember( {protocols.name}, {'.', '..'})) = [];  %remove . and ..
else
    protocols(~ismember( {protocols.name}, {app_properties.bst_protocols.protocol_name})) = []; 
end
if(~isempty(protocols))
    for i=1:length(protocols)
        protocol = protocols(i);
        disp(strcat("-->> Processing protocol: ", protocol.name))
        subjects = dir(fullfile(protocol.folder,protocol.name,'anat'));
        if(isequal(app_properties.bst_protocols.template.subject_name,"none") || isempty(app_properties.bst_protocols.template.subject_name))            
            subjects(ismember( {subjects.name}, {'.', '..', '@default_subject'})) = [];  %remove . and ..
        else
            subjects(~ismember( {subjects.name}, {app_properties.bst_protocols.template.subject_name})) = []; 
        end
        if(~isempty(subjects))
            for j=1:length(subjects)
                subject = subjects(j);
                disp(strcat("-->> Processing subject: ", subject.name));
                SubID = subject.name;
                eeg_meg_concurrency(fullfile(protocol.folder,protocol.name),paths,SubID)
            end
            disp('=================================================================')
        else
            isp("-->> No subject available in the specific path.");
        end
    end
else
    disp("-->> No protocol available in the specific path.");
end

disp(strcat("<<-- Process finished -->>"));


% disp(strcat("<<-- Selecting results -->>"));
% 
% subjects = dir('/data3_260T/data/CCLAB_DATASETS/HCP-GUSHI-2019/Run_1/EEGvsMEG_Concurrency_Output/');
% subjects(ismember( {subjects.name}, {'.', '..'})) = [];  %remove . and ..
% 
% mkdir(fullfile(paths.output_path,'Tensors'));
%
% time_freq3D = struct;
% time_freq3D.eLORETA.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.eLORETA.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.eLORETA.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.eLORETA.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.LCMV.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.LCMV.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.LCMV.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.LCMV.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBL.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBLpp.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLpp.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLpp.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLpp.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBL2Disotropic.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL2Disotropic.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL2Disotropic.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL2Disotropic.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBL3Disotropic.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL3Disotropic.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL3Disotropic.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBL3Disotropic.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBLlaplacian.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLlaplacian.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLlaplacian.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLlaplacian.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBLparcelled.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLparcelled.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLparcelled.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLparcelled.pvp3D = zeros(8002,5,length(subjects));
% 
% time_freq3D.sSSBLunwrapped.cor3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLunwrapped.pvc3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLunwrapped.pcr3D = zeros(8002,5,length(subjects));
% time_freq3D.sSSBLunwrapped.pvp3D = zeros(8002,5,length(subjects));
% 
% 
% space_freq3D = struct;
% 
% 
% space_freq3D.eLORETA.emd = cell(8,6,length(subjects));
% space_freq3D.eLORETA.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.eLORETA.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.eLORETA.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.eLORETA.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.eLORETA.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.eLORETA.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.eLORETA.cor = zeros(5,length(subjects));
% space_freq3D.eLORETA.pvc = zeros(5,length(subjects));
% space_freq3D.eLORETA.pcr = zeros(5,length(subjects));
% space_freq3D.eLORETA.pvp = zeros(5,length(subjects));
% space_freq3D.eLORETA.J1 = zeros(8002,5,length(subjects));
% space_freq3D.eLORETA.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.LCMV.emd = cell(8,6,length(subjects));
% space_freq3D.LCMV.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.LCMV.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.LCMV.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.LCMV.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.LCMV.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.LCMV.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.LCMV.cor = zeros(5,length(subjects));
% space_freq3D.LCMV.pvc = zeros(5,length(subjects));
% space_freq3D.LCMV.pcr = zeros(5,length(subjects));
% space_freq3D.LCMV.pvp = zeros(5,length(subjects));
% space_freq3D.LCMV.J1 = zeros(8002,5,length(subjects));
% space_freq3D.LCMV.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBL.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBL.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBL.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBL.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBL.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBL.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBL.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBL.cor = zeros(5,length(subjects));
% space_freq3D.sSSBL.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBL.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBL.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBL.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBL.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBLpp.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBLpp.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLpp.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBLpp.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBLpp.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBLpp.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLpp.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBLpp.cor = zeros(5,length(subjects));
% space_freq3D.sSSBLpp.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBLpp.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBLpp.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBLpp.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBLpp.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBL2Disotropic.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBL2Disotropic.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBL2Disotropic.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBL2Disotropic.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBL2Disotropic.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBL2Disotropic.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBL2Disotropic.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBL2Disotropic.cor = zeros(5,length(subjects));
% space_freq3D.sSSBL2Disotropic.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBL2Disotropic.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBL2Disotropic.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBL2Disotropic.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBL2Disotropic.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBL3Disotropic.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBL3Disotropic.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBL3Disotropic.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBL3Disotropic.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBL3Disotropic.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBL3Disotropic.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBL3Disotropic.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBL3Disotropic.cor = zeros(5,length(subjects));
% space_freq3D.sSSBL3Disotropic.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBL3Disotropic.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBL3Disotropic.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBL3Disotropic.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBL3Disotropic.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBLlaplacian.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBLlaplacian.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLlaplacian.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBLlaplacian.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBLlaplacian.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBLlaplacian.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLlaplacian.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBLlaplacian.cor = zeros(5,length(subjects));
% space_freq3D.sSSBLlaplacian.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBLlaplacian.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBLlaplacian.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBLlaplacian.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBLlaplacian.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBLparcelled.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBLparcelled.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLparcelled.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBLparcelled.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBLparcelled.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBLparcelled.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLparcelled.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBLparcelled.cor = zeros(5,length(subjects));
% space_freq3D.sSSBLparcelled.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBLparcelled.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBLparcelled.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBLparcelled.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBLparcelled.J2 = zeros(8002,5,length(subjects));
% 
% space_freq3D.sSSBLunwrapped.emd = cell(8,6,length(subjects));
% space_freq3D.sSSBLunwrapped.blur.blursd = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLunwrapped.blur.blurmode = zeros(5,2,length(subjects));
% space_freq3D.sSSBLunwrapped.blur.blurmax = zeros(5,2,length(subjects));
% space_freq3D.sSSBLunwrapped.blur.blurmean = zeros(5,2,length(subjects));
% space_freq3D.sSSBLunwrapped.blur.Rmode = zeros(5,2,8002,length(subjects));
% space_freq3D.sSSBLunwrapped.blur.ind_mode = cell(5,2,length(subjects));
% space_freq3D.sSSBLunwrapped.cor = zeros(5,length(subjects));
% space_freq3D.sSSBLunwrapped.pvc = zeros(5,length(subjects));
% space_freq3D.sSSBLunwrapped.pcr = zeros(5,length(subjects));
% space_freq3D.sSSBLunwrapped.pvp = zeros(5,length(subjects));
% space_freq3D.sSSBLunwrapped.J1 = zeros(8002,5,length(subjects));
% space_freq3D.sSSBLunwrapped.J2 = zeros(8002,5,length(subjects));
% 
% 
% for i=3:length(subjects)
%     subject = subjects(i);
%     disp(strcat("-->> Reading file for subject: ", subject.name));
%     time_freq_files = dir(fullfile(subject.folder,subject.name,'**','*time_freq.mat'));
%     for j=1:length(time_freq_files)
%         tf_file = time_freq_files(j);
%         load(fullfile(tf_file.folder,tf_file.name));
%         method = strsplit(tf_file.name,' ');
%         
%         switch method{1}
%             case 'eLORETA'
%                 time_freq3D.eLORETA.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.eLORETA.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.eLORETA.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.eLORETA.pvp3D(:,:,i) = time_freq.pvp;
%             case 'LCMV'
%                 time_freq3D.LCMV.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.LCMV.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.LCMV.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.LCMV.pvp3D(:,:,i) = time_freq.pvp;
%             case 'sSSBL'
%                 time_freq3D.sSSBL.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBL.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBL.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBL.pvp3D(:,:,i) = time_freq.pvp;
%             case 'sSSBL++'
%                 time_freq3D.sSSBLpp.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBLpp.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBLpp.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBLpp.pvp3D(:,:,i) = time_freq.pvp;
%             case  'sSSBL2Disotropic'
%                 time_freq3D.sSSBL2Disotropic.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBL2Disotropic.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBL2Disotropic.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBL2Disotropic.pvp3D(:,:,i) = time_freq.pvp;
%             case 'sSSBL3Disotropic'
%                 time_freq3D.sSSBL3Disotropic.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBL3Disotropic.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBL3Disotropic.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBL3Disotropic.pvp3D(:,:,i) = time_freq.pvp;
%             case 'sSSBLlaplacian'
%                 time_freq3D.sSSBLlaplacian.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBLlaplacian.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBLlaplacian.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBLlaplacian.pvp3D(:,:,i) = time_freq.pvp;
%             case 'sSSBLparcelled'
%                 time_freq3D.sSSBLparcelled.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBLparcelled.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBLparcelled.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBLparcelled.pvp3D(:,:,i) = time_freq.pvp;
%             case 'sSSBLunwrapped'
%                 time_freq3D.sSSBLunwrapped.cor3D(:,:,i) = time_freq.cor;
%                 time_freq3D.sSSBLunwrapped.pvc3D(:,:,i) = time_freq.pvc;
%                 time_freq3D.sSSBLunwrapped.pcr3D(:,:,i) = time_freq.pcr;
%                 time_freq3D.sSSBLunwrapped.pvp3D(:,:,i) = time_freq.pvp;
%         end
%         
%     end
%     
%     
%     space_freq_files = dir(fullfile(subject.folder,subject.name,'**','*space_freq.mat'));
%     for j=1:length(space_freq_files)
%         sf_file = space_freq_files(j);
%         load(fullfile(sf_file.folder,sf_file.name));
%         method = strsplit(sf_file.name,' ');
%         switch method{1}
%             case 'eLORETA'
%                 space_freq3D.eLORETA.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.eLORETA.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.eLORETA.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.eLORETA.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.eLORETA.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.eLORETA.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.eLORETA.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.eLORETA.cor(:,i) = space_freq.cor;
%                 space_freq3D.eLORETA.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.eLORETA.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.eLORETA.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.eLORETA.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.eLORETA.J2(:,:,i) = space_freq.J2;
%             case 'LCMV'
%                 space_freq3D.LCMV.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.LCMV.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.LCMV.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.LCMV.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.LCMV.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.LCMV.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.LCMV.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.LCMV.cor(:,i) = space_freq.cor;
%                 space_freq3D.LCMV.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.LCMV.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.LCMV.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.LCMV.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.LCMV.J2(:,:,i) = space_freq.J2;
%             case 'sSSBL'
%                 space_freq3D.sSSBL.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBL.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBL.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBL.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBL.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBL.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBL.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBL.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBL.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBL.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBL.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBL.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBL.J2(:,:,i) = space_freq.J2;
%             case 'sSSBL++'
%                 space_freq3D.sSSBLpp.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBLpp.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBLpp.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBLpp.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBLpp.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBLpp.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBLpp.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBLpp.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBLpp.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBLpp.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBLpp.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBLpp.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBLpp.J2(:,:,i) = space_freq.J2;
%             case  'sSSBL2Disotropic'
%                 space_freq3D.sSSBL2Disotropic.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBL2Disotropic.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBL2Disotropic.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBL2Disotropic.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBL2Disotropic.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBL2Disotropic.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBL2Disotropic.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBL2Disotropic.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBL2Disotropic.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBL2Disotropic.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBL2Disotropic.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBL2Disotropic.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBL2Disotropic.J2(:,:,i) = space_freq.J2;
%             case 'sSSBL3Disotropic'
%                 space_freq3D.sSSBL3Disotropic.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBL3Disotropic.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBL3Disotropic.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBL3Disotropic.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBL3Disotropic.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBL3Disotropic.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBL3Disotropic.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBL3Disotropic.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBL3Disotropic.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBL3Disotropic.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBL3Disotropic.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBL3Disotropic.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBL3Disotropic.J2(:,:,i) = space_freq.J2;
%             case 'sSSBLlaplacian'
%                 space_freq3D.sSSBLlaplacian.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBLlaplacian.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBLlaplacian.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBLlaplacian.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBLlaplacian.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBLlaplacian.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBLlaplacian.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBLlaplacian.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBLlaplacian.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBLlaplacian.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBLlaplacian.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBLlaplacian.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBLlaplacian.J2(:,:,i) = space_freq.J2;
%             case 'sSSBLparcelled'
%                 space_freq3D.sSSBLparcelled.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBLparcelled.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBLparcelled.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBLparcelled.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBLparcelled.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBLparcelled.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBLparcelled.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBLparcelled.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBLparcelled.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBLparcelled.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBLparcelled.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBLparcelled.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBLparcelled.J2(:,:,i) = space_freq.J2;
%             case 'sSSBLunwrapped'
%                 space_freq3D.sSSBLunwrapped.emd(:,:,i) = space_freq.emd;
%                 space_freq3D.sSSBLunwrapped.blursd(:,:,:,i) = space_freq.blur.blursd;
%                 space_freq3D.sSSBLunwrapped.blur.blurmode(:,:,i) = space_freq.blur.blurmode;
%                 space_freq3D.sSSBLunwrapped.blur.blurmax(:,:,i) = space_freq.blur.blurmax;
%                 space_freq3D.sSSBLunwrapped.blur.blurmean(:,:,i) = space_freq.blur.blurmean;
%                 space_freq3D.sSSBLunwrapped.Rmode(:,:,:,i) = space_freq.blur.Rmode;
%                 space_freq3D.sSSBLunwrapped.blur.ind_mode(:,:,i) = space_freq.blur.ind_mode;
%                 space_freq3D.sSSBLunwrapped.cor(:,i) = space_freq.cor;
%                 space_freq3D.sSSBLunwrapped.pvc(:,i) = space_freq.pvc;
%                 space_freq3D.sSSBLunwrapped.pcr(:,i) = space_freq.pcr;
%                 space_freq3D.sSSBLunwrapped.pvp(:,i) = space_freq.pvp;
%                 space_freq3D.sSSBLunwrapped.J1(:,:,i) = space_freq.J1;
%                 space_freq3D.sSSBLunwrapped.J2(:,:,i) = space_freq.J2;
%         end
%     end
%     
% end
% disp('-->> Saving time_freq file');
% %save('/data3_260T/data/CCLAB_DATASETS/HCP-GUSHI-1019/EEGvsMEG_Concurrency_Output/Tensors/time_freq3D.mat','time_freq3D','-v7.3');
% save(fullfile(paths.output_path,'Tensors/time_freq3D.mat'),'time_freq3D','-v7.3');
% 
% disp('-->> Saving space_freq file');
% %save('/data3_260T/data/CCLAB_DATASETS/HCP-GUSHI-1019/EEGvsMEG_Concurrency_Output/Tensors/space_freq3D.mat','space_freq3D','-v7.3');
% save(fullfile(paths.output_path,'Tensors/space_freq3D.mat'),'space_freq3D','-v7.3');


hours = fix(toc/3600);
minutes = fix(mod(toc,3600)/60);
disp(strcat("Elapsed time: ", num2str(hours) , " hours with ", num2str(minutes) , " minutes." ));
disp('=====================================================================');
disp(app_properties.generals.name);
disp('=====================================================================');


