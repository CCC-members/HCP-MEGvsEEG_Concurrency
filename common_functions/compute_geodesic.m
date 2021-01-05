function [d_dijkstra] = compute_geodesic(Vertices,Faces)
%% Initialization
Nv     = length(Vertices);
A_neig = zeros(Nv);
A_dist = zeros(Nv);

%% Cycle while the geodesic distance of the frontier to the center
for node = 1:Nv
    %% Search the neighbors of 'fpoint' out of the patche 'nfpoint'
    [row,col]   = find(Faces==node);
    neig_fpoint = Faces(row,:);
    neig_fpoint = neig_fpoint(:);
    neig_fpoint = setdiff(neig_fpoint,node);
    A_neig(node,neig_fpoint) = 1;
    %% Compute geodesic distance of the frontier points 'd'
    d           = Vertices(neig_fpoint,:) - repmat(Vertices(node,:),length(neig_fpoint),1);
    d           = (sqrt(sum(d.^2,2)));
    %% saving neigborn matrix
    A_dist(node,neig_fpoint) = d;
end

%% Compute geodesic distance of the frontier points 'd'
d_dijkstra = zeros(Nv);
for node = 1:(Nv-1)
        [parents, distance, path] = dijkstra(A_dist,node);          
        d_dijkstra(node,:)      = distance;
end

end