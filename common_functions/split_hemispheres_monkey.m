function [indvL,indvR,VerticesL,VerticesR,FacesL,FacesR] = split_hemispheres_monkey(surface)
Vertices       = surface.Vertices;
center         = min(Vertices,[],1) + (1/2)*(max(Vertices,[],1) - min(Vertices,[],1));
Vertices       = Vertices - repmat(center,size(Vertices,1),1);
Faces          = surface.Faces;
%% Compute indices and faces correspondign to Left Hemisphere and Right hemisphere
indvL          = find(Vertices(:,2) > 0);
VerticesL      = Vertices(indvL,:);
indvR          = find(Vertices(:,2) < 0);
VerticesR      = Vertices(indvR,:);
FacesL         = [];
FacesR         = [];
%%
cont2L      = 1;
cont2R      = 1;
for cont1 = 1:length(Faces)
    if sum(ismember(Faces(cont1,:),indvL),2) == 3
        FacesL(cont2L,:)    = Faces(cont1,:); 
        cont2L              = cont2L + 1;
    elseif sum(ismember(Faces(cont1,:),indvR),2) == 3
        FacesR(cont2R,:) = Faces(cont1,:); 
        cont2R           = cont2R + 1;
    end
end
counter  = 1;
maskL    = ones(size(FacesL));
for cont = indvL'
    FacesL(FacesL == cont*maskL) = counter;
    counter = counter + 1;
end
counter  = 1;
maskR    = ones(size(FacesR));
for cont = indvR'
    FacesR(FacesR == cont*maskR) = counter;
    counter = counter + 1;
end
end
%%