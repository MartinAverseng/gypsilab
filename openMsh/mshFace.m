function [mesh,elt2fce] = mshFace(mesh)
%+========================================================================+
%|                                                                        |
%|                 OPENMSH - LIBRARY FOR MESH MANAGEMENT                  |
%|           openMsh is part of the GYPSILAB toolbox for Matlab           |
%|                                                                        |
%| COPYRIGHT : Matthieu Aussal (c) 2017-2018.                             |
%| PROPERTY  : Centre de Mathematiques Appliquees, Ecole polytechnique,   |
%| route de Saclay, 91128 Palaiseau, France. All rights reserved.         |
%| LICENCE   : This program is free software, distributed in the hope that|
%| it will be useful, but WITHOUT ANY WARRANTY. Natively, you can use,    |
%| redistribute and/or modify it under the terms of the GNU General Public|
%| License, as published by the Free Software Foundation (version 3 or    |
%| later,  http://www.gnu.org/licenses). For private use, dual licencing  |
%| is available, please contact us to activate a "pay for remove" option. |
%| CONTACT   : matthieu.aussal@polytechnique.edu                          |
%| WEBSITE   : www.cmap.polytechnique.fr/~aussal/gypsilab                 |
%|                                                                        |
%| Please acknowledge the gypsilab toolbox in programs or publications in |
%| which you use it.                                                      |
%|________________________________________________________________________|
%|   '&`   |                                                              |
%|    #    |   FILE       : mshFace.m                                     |
%|    #    |   VERSION    : 0.40                                          |
%|   _#_   |   AUTHOR(S)  : Matthieu Aussal                               |
%|  ( # )  |   CREATION   : 14.03.2017                                    |
%|  / 0 \  |   LAST MODIF : 14.03.2018                                    |
%| ( === ) |   SYNOPSIS   : Submesh to face mesh                          |
%|  `---'  |                                                              |
%+========================================================================+

% Particles mesh
if (size(mesh.elt,2) == 1)
    error('mshFace.m : unavailable case')
    
% Edge mesh
elseif (size(mesh.elt,2) == 2)
    error('mshFace.m : unavailable case')
    
% Triangular mesh
elseif (size(mesh.elt,2) == 3)
    % Mesh unchanged.
    fce2vtx = mesh.elt;
    elt2fce = (1:size(mesh.elt,1))'; % Faces and elements are the same
    col     = mesh.col;
    
% Tetrahedral mesh
elseif (size(mesh.elt,2) == 4)
    % All faces
    fce2vtx = [ mesh.elt(:,[2,3,4]) ; mesh.elt(:,[3,4,1]) ; ...
        mesh.elt(:,[4,1,2]) ; mesh.elt(:,[1,2,3]) ];
    elt2fce = reshape(1:(4*length(mesh)),length(mesh),4);
    % Faces unicity
    tmp           = sort(fce2vtx,2);
    [~,I,J] = unique(tmp,'rows','stable');
    % I : indices of faces to keep
    % J : new names of faces (give same name to identical faces)
    elt2fce(:) = J(elt2fce(:)); % Translate in terms of unique face names
    
    % Final faces
    fce2vtx = fce2vtx(I,:); % Keep only one exemplary of each face
    
    % Colours
    col             = zeros(size(fce2vtx,1),1);
    tmp             = mesh.col * ones(1,4);
    col(elt2fce(:)) = tmp(:);
    
    % Identify boundary % what was this ?
    %     bnd      = ( accumarray(elt2fce(:),1).*col ~= accumarray(elt2fce(:),tmp(:)) );
    %     col(bnd) = -1;
    %
% Unknown type
else
    error('mshFace.m : unavailable case')
end

% Mesh format
mesh = msh(mesh.vtx,fce2vtx,col);
end
