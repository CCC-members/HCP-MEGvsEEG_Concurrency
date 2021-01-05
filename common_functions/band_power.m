function [J] = band_power(Data,J0,T,bands,band,F,ind,isfield)
%% For filtered time series
% Data         = Data(:,10001:18000);
J            = T(ind,:)*Data;
Jnorm        = sqrt(max(mean(abs(J).^2,2)));
scale        = sqrt(max(J0))/Jnorm;
J            = J*scale; %scaling

% if isfield == 1
%     J            = T(ind,:)*Data;
%     Jnorm        = sqrt(max(mean(abs(J).^2,2)));
%     scale        = sqrt(max(J0))/Jnorm;
%     J            = J*scale; %scaling
% elseif (isfield == 2) || (isfield == 3) %3D Lead Field
%     ind3D        = [3*ind-2 3*ind-1 3*ind];
%     ind3D        = ind3D';
%     ind3D        = ind3D(:);
%     J            = T(ind3D,:)*Data;
%     Jnorm        = mean(abs(J).^2,2);
%     Jnorm        = squeeze(sum(reshape(Jnorm,3,length(Jnorm)/3),1));
%     Jnorm        = sqrt(max(Jnorm));
%     scale        = sqrt(max(J0))/Jnorm;
%     J            = J*scale; %scaling
%     J            = abs(J).^2;
% end

%% For band power fluctuations
% f1               = bands(band,1); %frequency band lower limit
% f2               = bands(band,2); %frequency band upper limit
% [val,idf1]       = min(abs(F-f1));
% [val,idf2]       = min(abs(F-f2));
% Data             = Data(:,[idf1:idf2],:,:);
% [d1,d2,d3,d4]    = size(Data);
% Data             = reshape(Data,d1,d2*d3*d4);
% if isfield == 1
%     J            = T(ind,:)*Data;
%     Jnorm        = sqrt(max(mean(abs(J).^2,2)));
%     scale        = sqrt(max(J0))/Jnorm;
%     J            = J*scale; %scaling
%     d1           = size(J,1);
%     J            = abs(J).^2;
%     J            = squeeze(sum(reshape(J,d1,d2,d3*d4),2));
% elseif (isfield == 2) || (isfield == 3) %3D Lead Field
%     ind3D        = [3*ind-2 3*ind-1 3*ind];
%     ind3D        = ind3D';
%     ind3D        = ind3D(:);
%     J            = T(ind3D,:)*Data;
%     Jnorm        = mean(abs(J).^2,2);
%     Jnorm        = squeeze(sum(reshape(Jnorm,3,length(Jnorm)/3),1));
%     Jnorm        = sqrt(max(Jnorm));
%     scale        = sqrt(max(J0))/Jnorm;
%     J            = J*scale; %scaling
%     d1           = size(J,1);
%     J            = abs(J).^2;
%     J            = squeeze(sum(reshape(J,3,d1/3,d2,d3*d4),[1 3]));
% end
end