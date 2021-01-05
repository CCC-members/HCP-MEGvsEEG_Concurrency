function [cor,pvc,pcr,pvp] = corr_map(Vertices,Faces,J1,J2,Ngen,bands)
Nbands = length(bands);
cor    = zeros(Ngen,Nbands);
pvc    = zeros(Ngen,Nbands);
pcr    = zeros(Ngen,Nbands);
pvp    = zeros(Ngen,Nbands);
for gen = 1:Ngen
    [index,findex] = surfpatch(gen,Vertices,Faces);
    j1             = squeeze(J1(gen,:,:));
    j2             = squeeze(J2(gen,:,:));
    j1neigh        = squeeze(mean(J1(index,:,:),1));
    j2neigh        = squeeze(mean(J2(index,:,:),1));
    for band = 1:Nbands
        [P,p]          = corr([j1(:,band) j2(:,band) j1neigh(:,band) j2neigh(:,band)],'Type','Spearman');
        P              = P(1,2);
        p              = p(1,2);
        cor(gen,band)  = P;
        pvc(gen,band)  = p;
        [P,p]          = partialcorr([j1(:,band) j2(:,band) j1neigh(:,band) j2neigh(:,band)],'Type','Spearman');
        P              = P(1,2);
        p              = p(1,2);
        pcr(gen,band)  = P;
        pvp(gen,band)  = p;
    end
end

% for band = 1:Nbands
%     conn1 = corr(squeeze(J1(:,:,band))','Type','Spearman');
%     conn2 = corr(squeeze(J2(:,:,band))','Type','Spearman');
%     for gen = 1:Ngen
%         j1             = conn1(:,gen);
%         j1(gen)        = [];
%         j2             = conn2(:,gen);
%         j2(gen)        = [];
%         [P,p]          = corr([j1 j2],'Type','Spearman');
%         P              = P(1,2);
%         p              = p(1,2);
%         cor(gen,band)  = P;
%         pvc(gen,band)  = p;
%         [P,p]          = partialcorr([j1 j2],'Type','Spearman');
%         P              = P(1,2);
%         p              = p(1,2);
%         pcr(gen,band)  = P;
%         pvp(gen,band)  = p;
%     end
% end
end

