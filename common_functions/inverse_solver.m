function [T,J,stat,indms] = inverse_solver(L,parcellation,W,Svv,Nsamples,ismethod,isfield)
%% MEG Inverse solution filter
if ismethod == 1 % sSSBL
    [miu,sigma_post,T]    = sSSBLpp(Svv,L,Nsamples,W,parcellation);
%     [miu,sigma_post,T]    = sSSBLpp_ultralarge(Svv,L,Nsamples,parcellation);
    if (isfield == 2) || (isfield == 3) %3D Lead Field
        miu               = sum(reshape(abs(miu),3,length(L)/3),1)';
        sigma_post        = sum(reshape(abs(sigma_post),3,length(L)/3),1)';
    end
    stat                  = sqrt(miu./sigma_post);
    indms                 = find(stat > 0);
    J                     = zeros(length(stat),1);
    J(indms)              = miu(indms);
elseif ismethod > 1
    indms                 = [1:length(L)]';
    p                     = size(L,1);
    Ip                    = eye(p);
    scaleL                = sqrt(sum(abs(diag(L*L')))/p);
    L                     = L/scaleL;
    scaleV                = (sum(abs(diag(Svv)))/p);
    Svv                   = Svv/scaleV;
    gamma1                = 0;
    gamma2                = 2;
    delta_gamma           = 0.1;
    gamma_grid            = gamma1:delta_gamma:gamma2;
    gcv                   = zeros(length(gamma_grid),1);
    switch ismethod
        case 2
            count                 = 1;
            for gamma = gamma_grid
                [T,Wout]          = mkfilt_eloreta(L,10^gamma);
                T                 = T';
                Txiv              = Ip - L*T;
                gcv(count)        = (1/p)*sum(abs(diag(Txiv*Svv*Txiv')))/((1/p)*sum(abs(diag(Txiv))))^2;
                disp(['eloreta gcv param_' , num2str(gamma)])
                count             = count + 1;
            end
            [gcv_opt,idx_gamma]   = min(gcv);
            gamma                 = gamma_grid(idx_gamma);
            [T,Wout]              = mkfilt_eloreta(L,10^gamma);
        case 3
            count                 = 1;
            for gamma = gamma_grid
                [T,T1,Wout]       = mkfilt_lcmv(L,Svv,10^gamma);
                T                 = T';
                Txiv              = Ip - L*T;
                gcv(count)        = (1/p)*sum(abs(diag(Txiv*Svv*Txiv')))/((1/p)*sum(abs(diag(Txiv))))^2;
                disp(['lcmv gcv param_' , num2str(gamma)])
                count             = count + 1;
            end
            [gcv_opt,idx_gamma]   = min(gcv);
            gamma                 = gamma_grid(idx_gamma);
            [T,T1,Wout]           = mkfilt_lcmv(L,Svv,10^gamma);
    end
    T                     = transpose(T);
    J                     = abs(diag(T*Svv*T'));
    if isfield == 3 %3D Lead Field
        J                 = sum(reshape(abs(J),3,length(L)/3),1)';
    end
    stat                  = J;
end
end