function [] = corr_tri(J_eLORETA,J_sSSBLpp,band_label)
if length(J_sSSBLpp) == 2
    for band = 1:length(band_label)
        J_sSSBL{band}(:,1) = (J_sSSBLpp{1}{band}(:,1) + J_sSSBLpp{2}{band}(:,1))/2;
        J_sSSBL{band}(:,2) = (J_sSSBLpp{1}{band}(:,2) + J_sSSBLpp{2}{band}(:,2))/2;
    end
end
%% intra-band correlation...
p = zeros(2,length(band_label));
for band = 1:length(band_label)
    disp('eloreta')
    xx  = abs(J_eLORETA{band}(:,1))/max(abs(J_eLORETA{band}(:,1)));
    yy  = abs(J_eLORETA{band}(:,2))/max(abs(J_eLORETA{band}(:,2)));
    p(1,band) = corr(xx,yy);
    %     x = [xx,yy];
    %     p = kruskalwallis(x) % Nonparametric one-way analysis of variance (ANOVA)
    disp('sssbl++')
    xx  = abs(J_sSSBL{band}(:,1))/max(abs(J_sSSBL{band}(:,1)));
    yy  = abs(J_sSSBL{band}(:,2))/max(abs(J_sSSBL{band}(:,2)));
    p(2,band) = corr(xx,yy);
    %     x = [xx,yy];
    %     p = kruskalwallis(x) % Nonparametric one-way analysis of variance (ANOVA)
end
figure;
bar(p);
legend(band_label)
set(gca,'XTickLabel',{'eLORETA';'sSSBL++'});
ylabel('correlation coefficient');
ylim([0 1]);
title('Intra-bands correlation');

%% inter-band correlation...
p = zeros(2,2);
disp('eloreta')
xx = zeros(length(band_label),length(J_sSSBL{band}(:,1)));
for band = 1:length(band_label)
    xx(band,:)  = abs(J_eLORETA{band}(:,1))/max(abs(J_eLORETA{band}(:,1)));
end
p(1,1) = sum(sum(triu(corrcoef(xx'),1)))/10;

xx = zeros(length(band_label),length(J_sSSBL{band}(:,1)));
for band = 1:length(band_label)
    xx(band,:)  = abs(J_eLORETA{band}(:,2))/max(abs(J_eLORETA{band}(:,2)));
end
p(1,2) =  sum(sum(triu(corrcoef(xx'),1)))/10;

disp('ssbl++')
xx = zeros(length(band_label),length(J_sSSBL{band}(:,1)));
for band = 1:length(band_label)
    xx(band,:)  = abs(J_sSSBL{band}(:,1))/max(abs(J_sSSBL{band}(:,1)));
end
p(2,1) =  sum(sum(triu(corrcoef(xx'),1)))/10;

xx = zeros(length(band_label),length(J_sSSBL{band}(:,1)));
for band = 1:length(band_label)
    xx(band,:)  = abs(J_sSSBL{band}(:,2))/max(abs(J_sSSBL{band}(:,2)));
end
p(2,2) =  sum(sum(triu(corrcoef(xx'),1)))/10;

figure;
bar(p);
legend('MEG','EEG')
set(gca,'XTickLabel',{'eLORETA';'sSSBL++'});
ylabel('correlation coefficient');
ylim([0 1]);
title('Inter-bands correlation');
