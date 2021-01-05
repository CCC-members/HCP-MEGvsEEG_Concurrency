function [J1,J2] = power_samples(sim_data,J0,T,bands,ind,isfield)
L           = sim_data.structural.L_data2;
Nbands      = length(bands);
Nsegments   = 8;
GridOrient  = sim_data.structural.GridOrient;
GridAtlas   = sim_data.structural.GridAtlas;
for band = 1:Nbands
    T1                   = T{band}{1};
    T2                   = T{band}{2};
    %For filtered time series (project J2 on J1)
    if (isfield == 2) || (isfield == 3) %3D Lead Field
        T1               = bst_gain_orient(T1', GridOrient,GridAtlas);
        T1               = T1';
        T2               = bst_gain_orient(T2', GridOrient,GridAtlas);
        T2               = T2';
    end
    J01                  = J0{band}(:,1);
    J02                  = J0{band}(:,2);
    for seg = 1:Nsegments
        % source 1
        data1                = sim_data.functional.data1.Data_TS{seg,band}; %Data_FC for band power and Data_TS{band} for filtered time series
        F1                   = sim_data.functional.data1.F;
        J1(:,:,band,seg)     = band_power(data1,J01,T1,bands,band,F1,ind,isfield);
        % source 2
        data2                = L*squeeze(J1(:,:,band,seg));
        %     data2                = sim_data.functional.data2.Data_TS{band}; %Data_FC for band power and Data_TS{band} for filtered time series
        F2                   = sim_data.functional.data2.F;
        J2(:,:,band)         = band_power(data2,J02,T2,bands,band,F2,ind,isfield);
    end
end
end