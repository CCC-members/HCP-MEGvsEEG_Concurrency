function [mapsfig1,mapsfig2,mapsfig3] = figure_blur(paths,sim_data,space_freq,band_label,method_label)
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
%%
mapsfig1             = figure('Color','w','Name',strcat(method_label,'  Mode PSF'));
for band = 1:length(band_label)
    %% Source 1
    J1                     = squeeze(space_freq.blur.Rmode(band,1,:));
    map1                   = zeros(Ngen,1);
    map1(ind)              = J1(ind);
    map1                   = abs(map1)/max(abs(map1));
    %% Source 2
    J2                     = squeeze(space_freq.blur.Rmode(band,2,:));
    map2                   = zeros(Ngen,1);
    map2(ind)              = J2(ind);
    map2                   = abs(map2)/max(abs(map2));
    %% Plot Source1/Source2 (8 subplots)
    %1-----------------------------------------------------------------------
    subplot(10,4,8*(band-1)+1)
    patch('Faces',Faces,'Vertices',Vertices,'FaceVertexCData',Sulc*0.06+...
        log10(map1),'FaceColor','interp','EdgeColor','none','FaceAlpha',.99);
    colormap(gca,cmap);
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
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
    ind_mode = squeeze(space_freq.blur.ind_mode{band,1});
    hold on; scatter3(Vertices(ind_mode,1),Vertices(ind_mode,2),Vertices(ind_mode,3),2,'filled')
    axis off
    set(gca,'xcolor','w','ycolor','w','zcolor','w');
    view(180,-90);
    text(max(Vertices(:,1)),max(Vertices(:,2)),min(Vertices(:,3)),'V')
    %8------------------------------------------------------------------------
end
file_name = strcat(method_label,'_Mode_PSF','.fig');
savefig(mapsfig1,fullfile(paths.output_path,file_name));
close(mapsfig1);
%%
mapsfig2             = figure('Color','w','Name',strcat(method_label,' Mode PSF Histogram'));
for band = 1:length(band_label)
    %% Source 1
    J1                     = squeeze(space_freq.blur.Rmode(band,1,:));
    map1                   = zeros(Ngen,1);
    map1(ind)              = J1(ind);
    map1                   = map1/max(map1);
    %% Source 2
    J2                     = squeeze(space_freq.blur.Rmode(band,2,:));
    map2                   = zeros(Ngen,1);
    map2(ind)              = J2(ind);
    map2                   = map2/max(map2);
    %%
    subplot(5,2,2*(band-1)+1); hist(map1);
    modeval              = num2str(space_freq.blur.blurmode(band,1));
    ttl = strcat('MEG-PSF',' SD:', modeval);
    title(ttl);
    subplot(5,2,2*(band-1)+2); hist(map2);
    modeval              = num2str(space_freq.blur.blurmode(band,2));
    ttl = strcat('EEG-PSF',' SD:', modeval);
    title(ttl);
end
file_name = strcat(method_label,'_ModePSF_Hist','.fig');
savefig(mapsfig2,fullfile(paths.output_path,file_name));
close(mapsfig2);
%%
mapsfig3             = figure('Color','w','Name',strcat(method_label,'  SD Histogram'));
for band = 1:length(band_label)
    J1                   = squeeze(space_freq.blur.blursd(band,1,:));
    J2                   = squeeze(space_freq.blur.blursd(band,2,:));
    map1                 = J1(ind);
    map2                 = J2(ind);
    subplot(5,2,2*(band-1)+1); hist(map1);
    modeval              = num2str(space_freq.blur.blurmode(band,1));
    ttl = strcat('MEG-SD',' Mode:', modeval);
    title(ttl);
    subplot(5,2,2*(band-1)+2); hist(map2);
    modeval              = num2str(space_freq.blur.blurmode(band,2));
    ttl = strcat('EEG-SD',' Mode:', modeval);
    title(ttl);
end
file_name = strcat(method_label,'_SD_Hist','.fig');
savefig(mapsfig3,fullfile(paths.output_path,file_name));
close(mapsfig3);