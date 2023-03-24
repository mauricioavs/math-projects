disp("Running...")
function X = hexgrid(bb,spacing)
% Function hexgrid: uniform hexagonal grid
% 
% Generates a uniform hexagonal grid with grid step given by 'spacing' such that
% the bounding box defined by 'bb' is covered by the hex grid, 
% one of the directions of the hex grid is paralell to the x-axis, and
% a grid point is placed at the botton left corner of bb
%
% INPUT
%
%  bb -- a boundung box defined by its diagonal points: a 2 x 2 matrix with the two points in rows
%  spacing -- a real number, distance to the closest neighbor in the hex grid
%
% OUTPUT
%
%  X -- a matrix of the grid points in rows
%
% COPYRIGHT & LICENSE
%
% Copyright (C) 2019-2020 Oleg Davydov <oleg.davydov@math.uni-giessen.de>
%
% This file is part of mFDlab released under GNU General Public License v2.0.
% See the file README for further details.


%shift the bounding box to place the botton left corner to the origin
corner = bb(1,:);
bb = bb - corner;

%set hexagonal transformation matrix and inverse
HT = [1 1/2; 0 sqrt(3)/2]'; %transposed since we multiply point matrices from the right to transform
HTi = [1 -sqrt(3)/3; 0 2*sqrt(3)/3]';

%create bounding box for the integer lattice
bbHv = [bb; bb(1,1) bb(2,2); bb(2,1) bb(1,2)]*HTi; %vertices of the preimage of bb
bbH = [floor(min(bbHv)/spacing); ceil(max(bbHv)/spacing)];  %integer bounding box for it

%integer cartesian grid as preimage
[XH,YH] = meshgrid(bbH(1,1):bbH(2,1),bbH(1,2):bbH(2,2));

%hex grid by tranformation
X = spacing*[XH(:) YH(:)]*HT;

%translate the grid to the actual bounding box
X = X + corner;

end

X = hexgrid([1, 1;1, 1], 0.5)