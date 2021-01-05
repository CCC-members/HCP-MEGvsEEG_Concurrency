function [mapsfig1,mapsfig2,mapsfig3,mapsfig4] = figure_concurrency(paths,sim_data,data0,J0,space_freq,time_freq,band_label,method_label)
%% Parameters
%% Colormap
load('mycolor.mat');
load('cmap_pearson');
load('cmap_pval');
surface              = sim_data.structural.surface;
Vertices             = surface.Vertices;
Ngen                 = length(Vertices);
Faces                = surface.Faces;
VertConn             = surface.VertConn;
smoothValue          = 0.66;
SurfSmoothIterations = 10;
Vertices             = tess_smooth(Vertices, smoothValue, SurfSmoothIterations, VertConn, 1);
Sulc                 = surface.SulciMap;
ind                  = [1:length(Vertices)]';
if length(J0) == length(band_label)
    J       = J0;
elseif length(J0) == 2
    for band = 1:length(band_label)
    J{band} = (J0{1}{band} + J0{2}{band})/2;
    end
end
%%
mapsfig1             = figure('Color','w','Name',strcat(method_label,'  MEG/EEG activation'));
for band = 1:length(band_label)
    %% Source 1
    J1                     = J{band}(:,1);
    map1                   = zeros(Ngen,1);
    map1(ind)              = J1(ind);
    map1                   = map1/max(map1);
    %% Source 2
    J2                     = J{band}(:,2);
    map2                   = zeros(Ngen,1);
    map2(ind)              = J2(ind);
    map2                   = map2/max(map2);
    %% Plot Source1/Source2 (8 subplots)
    %1-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+1)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,0);
    text(max(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'L')
    %1-----------------------------------------------------------------------
    if band == 1
        title(['MinNorm' ' ' 'MEG'])
    end
    
    %2-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+2)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,90);
    text(max(Vertices(:,1)),min(Vertices(:,2)),max(Vertices(:,3)),'D')
    %2-----------------------------------------------------------------------
    if band == 1
        title(['MinNorm' ' ' 'MEG'])
    end
    
    %3-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+3)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map2),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,0);
    text(max(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'L')
    %3-----------------------------------------------------------------------
    if band == 1
        title([method_label ' ' 'EEG'])
    end
    
    %4-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+4)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map2),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,90);
    text(max(Vertices(:,1)),min(Vertices(:,2)),max(Vertices(:,3)),'D')
    %4-----------------------------------------------------------------------
    if band == 1
        title([method_label ' ' 'EEG'])
    end
    
    %5-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+5)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(-90,0);
    text(min(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'P')
    %5------------------------------------------------------------------------
    
    %6------------------------------------------------------------------------
    subplot(10,4,8*(band-1)+6)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,-90);
    text(max(Vertices(:,1)),max(Vertices(:,2)),min(Vertices(:,3)),'V')
    %6------------------------------------------------------------------------
    
    %7------------------------------------------------------------------------
    subplot(10,4,8*(band-1)+7)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map2),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(-90,0);
    text(min(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'P')
    %7------------------------------------------------------------------------
    
    %8------------------------------------------------------------------------
    subplot(10,4,8*(band-1)+8)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map2),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,-90);
    text(max(Vertices(:,1)),max(Vertices(:,2)),min(Vertices(:,3)),'V')
    %8------------------------------------------------------------------------
end
file_name = strcat(method_label,'_MEEG_activation','.fig');
savefig(mapsfig1,fullfile(paths.output_path,file_name));
close(mapsfig1);
%%
mapsfig2             = figure('Color','w','Name',strcat(method_label,'  Temporal P/Corr'));
for band = 1:length(band_label)
    %% Partial Correlations
    pcr                     = time_freq.pcr(:,band);
    map1(ind)               = pcr;
    map1(map1 <= 0)         = -0.05;
    map1(map1 >= 0.5)       = 0.5;
    %% P-value
    pvp                     = time_freq.pvp(:,band);
    map2(ind)               = pvp;
    map2(map2 > 0.05)       = 0.052;
    map2(map1 <= 0)         = 0.052;   
    map1(map2 > 0.05)       = -0.05;
    %% Plot PartialCorrelations/P-value
    %1-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+1)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pearson);
    caxis([0 0.5]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,0);
    text(max(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'L')
    %1-----------------------------------------------------------------------
    if band == 1
        title('PCorr(p-val<=0.05*)')
    end
    
    %2-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+2)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pearson);
    caxis([0 0.5]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,90);
    text(max(Vertices(:,1)),min(Vertices(:,2)),max(Vertices(:,3)),'D')
    %2-----------------------------------------------------------------------
    if band == 1
        title('PCorr(p-val<=0.05*)')
    end
    
    %3-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+3)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map2,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pval);
    caxis([0 0.05]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,0);
    text(max(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'L')
    %3-----------------------------------------------------------------------
    if band == 1
        title('p-val<=0.05*')
    end
    
    %4-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+4)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map2,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pval);
    caxis([0 0.05]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,90);
    text(max(Vertices(:,1)),min(Vertices(:,2)),max(Vertices(:,3)),'D')
    %4-----------------------------------------------------------------------
    if band == 1
        title('p-val<=0.05*')
    end
    
    %5-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+5)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pearson);
    caxis([0 0.5]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(-90,0);
    text(min(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'P')
    %5------------------------------------------------------------------------
    
    %6------------------------------------------------------------------------
    subplot(10,4,8*(band-1)+6)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map1,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pearson);
    caxis([0 0.5]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,-90);
    text(max(Vertices(:,1)),max(Vertices(:,2)),min(Vertices(:,3)),'V')
    %6------------------------------------------------------------------------
    
    %7------------------------------------------------------------------------
    subplot(10,4,8*(band-1)+7)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map2,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pval);
    caxis([0 0.05]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(-90,0);
    text(min(Vertices(:,1)),max(Vertices(:,2)),max(Vertices(:,3)),'P')
    %7------------------------------------------------------------------------
    
    %8------------------------------------------------------------------------
    subplot(10,4,8*(band-1)+8)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        map2,'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap_pval);
    caxis([0 0.05]);
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,-90);
    text(max(Vertices(:,1)),max(Vertices(:,2)),min(Vertices(:,3)),'V')
    %8------------------------------------------------------------------------
end
file_name = strcat(method_label,'_Temporal_PCorr','.fig');
savefig(mapsfig2,fullfile(paths.output_path,file_name));
close(mapsfig2);
%%
mapsfig3             = figure('Color','w','Name',strcat(method_label,'  Spatial P/Corr'));
for band = 1:length(band_label)
    J1                   = J{band}(:,1);
    J2                   = J{band}(:,2);
    map1                 = J1(ind);
    map2                 = J2(ind);
    map12                = map1.*map2;
    map1(map12 < 1E-10)   = [];
    map2(map12 < 1E-10)   = [];
    map1                 = log(map1);
    map2                 = log(map2);

%     J1                   = space_freq.J1(:,band);
%     map1                 = J1(ind);
%     map1                 = log(map1 - min(map1) + 1);
%     J2                   = space_freq.J2(:,band);
%     map2                 = J2(ind);
%     map2                 = log(map2 - min(map2) + 1);
    mdl                  = LinearModel.fit(map1,map2,'VarNames',{'meg','eeg'});
    subplot(5,1,band); plot(mdl);
    cor                  = num2str(round(space_freq.cor(band),4));
    pvc                  = space_freq.pvc(band);
    if pvc > 0.05
        p_val = ">0.05ns";
    elseif (pvc > 0.01) && (pvc <= 0.05)
        p_val = "<=0.05*";
    elseif (pvc > 0.001) && (pvc <= 0.01)
        p_val = "<=0.01**";
    elseif (pvc > 0.0001) && (pvc <= 0.001)
        p_val = "<=0.001***";
    elseif pvc <= 0.0001
        p_val = "<=0.0001****";
    end
    ttl = strcat('Corr:', cor, '  P-val:', p_val);
    title(ttl);
end
file_name = strcat(method_label,'_Spatial_PCorr','.fig');
savefig(mapsfig3,fullfile(paths.output_path,file_name));
close(mapsfig3);
%% Sensor level figure
MEG_Channel          = sim_data.structural.data1_channel.Channel;
EEG_Channel          = sim_data.structural.data2_channel.Channel;
elec_meg             = [];
elec_meg.pos         = zeros(length(MEG_Channel),3);
for ii = 1:length(MEG_Channel)
    elec_meg.lbl{ii}   = MEG_Channel(ii).Name;
    temp               = MEG_Channel(ii).Loc;
    elec_meg.pos(ii,:) = mean(temp,2);
end
elec_meg.label       = elec_meg.lbl;
elec_meg.elecpos     = elec_meg.pos;
elec_meg.unit        = 'mm';
elec_eeg             = [];
elec_eeg.pos = zeros(length(EEG_Channel),3);
for ii = 1:length(EEG_Channel)
    elec_eeg.lbl{ii}   = EEG_Channel(ii).Name;
    temp               = EEG_Channel(ii).Loc;
    elec_eeg.pos(ii,:) = temp;
end
elec_eeg.label       = elec_eeg.lbl;
elec_eeg.elecpos     = elec_eeg.pos;
elec_eeg.unit        = 'mm';
if length(data0) == 2
    for band = 1:length(band_label)
        data{band}{1}   = (data0{1}{band}{1}+data0{2}{band}{1})/2;
        data{band}{2}   = (data0{1}{band}{2}+data0{2}{band}{2})/2;
    end
else
    data = data0;
end
mapsfig4             = figure('Color','w','Name',strcat(method_label,'  MEG/EEG topography'));
for band = 1:length(band_label)
    %% MEG topography
    subplot(5,2,2*(band-1)+1)
    temp             = diag(data{band}{1});
    temp             = abs(temp)/max(abs(temp(:)));
    cfg              = [];
    meg              = [];
    cfg.layout       = '4D248_helmet.mat';
    cfg.channel      = 'meg';
    cfg.markers      = '.';
    cfg.markersymbol = '.';
    cfg.colormap     = cmap;
    cfg.markersize   = 3;
    cfg.markercolor  = [1 1 1];
    meg.sens         = elec_meg;
    meg.tra          = elec_meg.pos;
    meg.coilpos      = elec_meg.pos;
    meg.label        = elec_meg.lbl;
    meg.dimord       = 'chan_freq';
    meg.freq         = band;
    meg.powspctrm    = temp;
    ft_topoplotTFR(cfg,meg);
    title(['MEG' ' ' band_label{band} ' ' 'topography'])
    
    %% EEG topography
    subplot(5,2,2*(band-1)+2)
    temp             = data{band}{2};
    temp             = abs(temp)/max(abs(temp(:)));
    cfg              = [];
    eeg              = [];
    cfg.marker       = '';
    cfg.layout       = 'EEG1020.lay';
    cfg.channel      = 'eeg';
    cfg.markersymbol = '.';
    cfg.colormap     = cmap;
    cfg.markersize   = 3;
    cfg.markercolor  = [1 1 1];
    eeg.elec         = elec_eeg;
    eeg.label        = elec_eeg.lbl;
    eeg.dimord       = 'chan_freq';
    eeg.freq         = band;
    eeg.powspctrm    = temp;
    ft_topoplotTFR(cfg,eeg);
    title(['EEG' ' ' band_label{band} ' ' 'topography'])
end
file_name = strcat(method_label,'_MEEG_topography','.fig');
savefig(mapsfig4,fullfile(paths.output_path,file_name));
close(mapsfig4);
end
