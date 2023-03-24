function [nodes] = generate_bnodes_uniform (init_angle,domain,nodes)
% Function generate_bnodes_uniform: uniform nodes on circles
%
% Generates boundary nodes by projecting some of exisiting interior nodes to the boundary
%
% INPUT
%
% init_angle - angle of the first point on the circle
% domain - structure describing the domain we generate the nodes for
% nodes -- structure containing existing interior nodes
%
% OUTPUT
%
% nodes -- the nodes structure completed with boundary nodes
%
% TODO: extend to polygonal boundaries
%
%
% COPYRIGHT & LICENSE
%
% Copyright (C) 2019-2020 Oleg Davydov <oleg.davydov@math.uni-giessen.de>
%
% This file is part of mFDlab released under GNU General Public License v2.0.
% See the file README for further details.


%
if domain.dim ~= 2 || ~ismember(domain.id,{'unit ball','ball','ball\ball'})
    error('uniform boundary nodes are not available for this domain')
end



%determine target spacing of nodes from known spacing of interior nodes
if strcmp(nodes.itype,'grid')
    spacing = nodes.h; %this uses step size of the uniform grid
else
    spacing = nodes.spacing; %approximate spacing (assuming quasi-uniform nodes)
end

switch domain.id
    
    case {'unit ball','ball'}
        
        twopi = 2*pi;
        
        %determine angle step h for 1d grid points
        gridpar = round(twopi*domain.radius/spacing);
        h = twopi/gridpar;
        %h=h/2; %experimenting with denser or coarse sets of points comparing to the interior spacing
        
        %generate points
        t = init_angle + (0:h:twopi-h/2)';
        Xb = domain.center + domain.radius*[cos(t) sin(t)];
    
    case 'ball\ball'
        
        twopi = 2*pi;
        
        %%outer boundary
        
        %determine angle step h for 1d grid points
        gridpar = round(twopi*2/spacing);
        h = twopi/gridpar;
        %h=h/2; %experimenting with denser or coarse sets of points comparing to the interior spacing
        
        %generate points
        t = init_angle + (0:h:twopi-h/2)';
        Xb = 2*[cos(t) sin(t)];
        
        %%inner boundary
        
        %determine angle step h for 1d grid points
        gridpar = round(twopi/spacing);
        h = twopi/gridpar;
        %h=h/2; %experimenting with denser or coarse sets of points comparing to the interior spacing
        
        %generate points
        t = init_angle + (0:h:twopi-h/2)';
        Xb = [Xb; domain.inner_center + [cos(t) sin(t)]];
       
end


%add the boundary points to nodes structure
nodes.X = [nodes.X; Xb];
nodes.ib = length(nodes.ii)+1 : size(nodes.X,1); %indices of boundary nodes

% %messages/visualization
% disp('boundary nodes: projection')
% disp(['  project interior nodes with distance from boundary < ',num2str(spacing_coef),'*h'])
% if dim==2, figure(88), plot(Xb(:,1),Xb(:,2),'*'), axis([-2 2 -2 2]), end

