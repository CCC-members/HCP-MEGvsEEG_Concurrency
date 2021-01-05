function [J,stat,indms,T,data] = concurrency(sim_data,bands,ismethod,isparcel,isneigh,isfield,iscurv)
%% Parameters
F_data1        = sim_data.functional.data1.F;
Svvdata2       = sim_data.functional.data2.Svvdata2;
Nsegmentsdata1 = sim_data.functional.data1.Nsegments;
GridOrient     = sim_data.structural.GridOrient;
GridAtlas      = sim_data.structural.GridAtlas;
%% parcel/field options
if isparcel == 0
    if (isfield == 1) || (isfield == 2)
        parcellation  = sim_data.structural.parcellation_none;
    elseif isfield == 3
        parcellation  = sim_data.structural.parcellation_none3D;
    end
elseif isparcel == 1
    if (isfield == 1) || (isfield == 2)
        parcellation  = sim_data.structural.parcellation;
    elseif isfield == 3
        parcellation  = sim_data.structural.parcellation3D;
    end
end

%% neigh/field options
if isneigh == 0
    if isfield == 1
        W  = speye(length(sim_data.structural.surface.Vertices));
    elseif isfield == 2
        W  = sim_data.structural.Ninv;
    elseif isfield == 3
        W  = speye(3*length(sim_data.structural.surface.Vertices));
    end
elseif isneigh == 1
    if isfield == 1
        W  = sim_data.structural.Dinv;
    elseif isfield == 2
        W  = sim_data.structural.DNinv;
    elseif isfield == 3
        W  = sim_data.structural.D3Dinv;
    end
end

%% curv/field options
if iscurv == 0
    if isfield == 1
        L_data1 = sim_data.structural.L_data1;
        L_data2 = sim_data.structural.L_data2;
    elseif (isfield == 2) || (isfield == 3)
        L_data1 = sim_data.structural.L_data13D;
        L_data2 = sim_data.structural.L_data23D;
    end
elseif iscurv == 1
    if isfield == 1
        L_data1 = sim_data.structural.L_data1giri;
        L_data2 = sim_data.structural.L_data2giri;
    elseif (isfield == 2) || (isfield == 3)
        L_data1 = sim_data.structural.L_data13Dgiri;
        L_data2 = sim_data.structural.L_data23Dgiri;
    end
elseif iscurv == -1
    if isfield == 1
        L_data1 = sim_data.structural.L_data1sulc;
        L_data2 = sim_data.structural.L_data2sulc;
    elseif (isfield == 2) || (isfield == 3)
        L_data1 = sim_data.structural.L_data13Dsulc;
        L_data2 = sim_data.structural.L_data23Dsulc;
    end
end

%%
for band = 1:size(bands,1)
    F1           = bands(band,1); %frequency band lower limit
    F2           = bands(band,2); %frequency band upper limit
    
    %% data1 Inverse solution filter
    [val,idf1]   = min(abs(F_data1-F1));
    [val,idf2]   = min(abs(F_data1-F2));
    Nsamples     = Nsegmentsdata1*(idf2-idf1+1);
    J_data1      = sim_data.functional.data1.J{band};
    statdata1    = sim_data.functional.data1.stat{band};
    indmsdata1   = sim_data.functional.data1.indms{band};
    Svvdata1band = sim_data.functional.data1.Svvdata1{band};
    Tdata1band   = sim_data.functional.data1.T{band};
    if isfield == 1
        Tdata1band            = bst_gain_orient(Tdata1band', GridOrient,GridAtlas);
        Tdata1band            = Tdata1band';
        T_data1               = zeros(size(Tdata1band,1),size(Tdata1band,2));
        T_data1(indmsdata1,:) = Tdata1band(indmsdata1,:);
    else
        indms3D               = [3*indmsdata1-2 3*indmsdata1-1 3*indmsdata1];
        indms3D               = indms3D';
        indms3D               = indms3D(:);
        T_data1               = zeros(size(Tdata1band,1),size(Tdata1band,2));
        T_data1(indms3D,:)    = Tdata1band(indms3D,:);
    end
    
    %% data2 inverse solution filter
    Svvdata2band           = Svvdata2{band};
    [Svvdata2band,L_data2] = applying_reference(Svvdata2band,L_data2);
    [T_data2,J_data2,statdata2,indmsdata2] = inverse_solver(L_data2,parcellation,W,Svvdata2band,Nsamples,ismethod,isfield);
    
    %% Saving solutions
    J{band}        = [J_data1 J_data2];
    stat{band}     = [statdata1 statdata2];
    indms{band}    = {indmsdata1 indmsdata2}; 
    data{band}     = {Svvdata1band Svvdata2band};
    T{band}        = {T_data1 T_data2};
end