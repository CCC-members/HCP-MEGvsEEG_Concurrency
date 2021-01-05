function [blur] = blur_transfer(sim_data,J,T,bands,ind,isfield,iscurv)
Nbands      = length(bands);
GridOrient  = sim_data.structural.GridOrient;
GridAtlas   = sim_data.structural.GridAtlas;
d_disktra   = sim_data.structural.surface.d_dijkstra(ind,ind).^2;
d_disktra(d_disktra > 100) = 0;
for band = 1:Nbands
    if iscurv == 0
        J1               = J{band}(:,1);
        T1               = T{band}{1};
        T2               = T{band}{2};        
        if (isfield == 2) || (isfield == 3) %3D Lead Field
            T1           = bst_gain_orient(T1', GridOrient,GridAtlas);
            T1           = T1';            
            T2           = bst_gain_orient(T2', GridOrient,GridAtlas);
            T2           = T2';
        end
        J1               = J1(ind,:);
        T1               = T1(ind,:);
        T2               = T2(ind,:);
        L1               = sim_data.structural.L_data1(:,ind);
        L2               = sim_data.structural.L_data2(:,ind);
        % pick points 
        th               = quantile(J1,0.75);
        tmp_ind          = find(J1 > th);
        % spatial dispersion
        R                = T1*L1;
        tmp_sd           = sqrt(sum(abs(R).*d_disktra,1))./sqrt(sum(abs(R-diag(diag(R))),1));
        blursd(band,1,:) = tmp_sd;
        [count,centers]  = hist(tmp_sd);
        [val,indval]     = max(count);
        blurmode(band,1) = centers(indval);
        blurmax(band,1)  = max(tmp_sd(tmp_ind));
        blurmean(band,1) = mean(tmp_sd(tmp_ind));
        Rmode(band,1,:)  = mean(abs(R(:,tmp_ind)),2);
        ind_mode{band,1} = tmp_ind;
        R                = T2*L2;
        tmp_sd           = sqrt(sum(abs(R).*d_disktra,1))./sqrt(sum(abs(R-diag(diag(R))),1));
        blursd(band,2,:) = tmp_sd;
        [count,centers]  = hist(tmp_sd);
        [val,indval]     = max(count);
        blurmode(band,2) = centers(indval);
        blurmax(band,2)  = max(tmp_sd(tmp_ind));
        blurmean(band,2) = mean(tmp_sd(tmp_ind));
        Rmode(band,2,:)  = mean(abs(R(:,tmp_ind)),2);
        ind_mode{band,2} = tmp_ind;
    else
        J1giri           = J{1}{band}(:,1);
        J1sulc           = J{2}{band}(:,1);
        T1giri           = T{1}{band}{1};
        T1sulc           = T{2}{band}{1};
        T2giri           = T{1}{band}{2};
        T2sulc           = T{2}{band}{2};
        if (isfield == 2) || (isfield == 3) %3D Lead Field
            T1giri       = bst_gain_orient(T1giri', GridOrient,GridAtlas);
            T1giri       = T1giri';            
            T1sulc       = bst_gain_orient(T1sulc', GridOrient,GridAtlas);
            T1sulc       = T1sulc';            
            T2giri       = bst_gain_orient(T2giri', GridOrient,GridAtlas);
            T2giri       = T2giri';            
            T2sulc       = bst_gain_orient(T2sulc', GridOrient,GridAtlas);
            T2sulc       = T2sulc';
        end
        J1giri           = J1giri(ind,:);
        J1sulc           = J1sulc(ind,:);
        T1giri           = T1giri(ind,:);
        T1sulc           = T1sulc(ind,:);
        T2giri           = T2giri(ind,:);
        T2sulc           = T2sulc(ind,:);
        L1giri           = sim_data.structural.L_data1giri(:,ind);
        L1sulc           = sim_data.structural.L_data1sulc(:,ind);
        L2giri           = sim_data.structural.L_data2giri(:,ind);
        L2sulc           = sim_data.structural.L_data2sulc(:,ind);
        % pick point
        th               = quantile((J1giri + J1sulc)/2,0.75);
        tmp_ind          = find((J1giri + J1sulc)/2 > th);
        % spatial dispersion
        R                = (T1giri*L1giri + T1sulc*L1sulc)/2;
        tmp_sd           = sqrt(sum(abs(R).*d_disktra,1))./sqrt(sum(abs(R-diag(diag(R))),1));
        blursd(band,1,:) = tmp_sd;
        [count,centers]  = hist(tmp_sd);
        [val,indval]     = max(count);
        blurmode(band,1) = centers(indval);
        blurmax(band,1)  = max(tmp_sd(tmp_ind));
        blurmean(band,1) = mean(tmp_sd(tmp_ind));
        Rmode(band,1,:)  = mean(abs(R(:,tmp_ind)),2);
        ind_mode{band,1} = tmp_ind;
        R                = (T2giri*L2giri + T2sulc*L2sulc)/2;
        tmp_sd           = sqrt(sum(abs(R).*d_disktra,1))./sqrt(sum(abs(R-diag(diag(R))),1));
        blursd(band,2,:) = tmp_sd;
        [count,centers]  = hist(tmp_sd);
        [val,indval]     = max(count);
        blurmode(band,2) = centers(indval);
        blurmax(band,2)  = max(tmp_sd(tmp_ind));
        blurmean(band,2) = mean(tmp_sd(tmp_ind));
        Rmode(band,2,:)  = mean(abs(R(:,tmp_ind)),2);
        ind_mode{band,2} = tmp_ind;
    end
end
blur.blursd    = blursd;
blur.blurmode  = blurmode;
blur.blurmax   = blurmax;
blur.blurmean  = blurmean;
blur.Rmode     = Rmode;
blur.ind_mode  = ind_mode;
end