function mshPlot(mesh,color)

if ~exist('color','var')
    color = mesh.col;
end


if isempty(color)
    color = 1;
end
if isscalar(color)&&~ischar(color)
    color = repmat(color,mesh.nvtx,1);
end

% Patch
H = patch('Faces',mesh.elt, 'Vertices',mesh.vtx,'Marker','o');

switch mesh.type
    case 'point'
        if ischar(color)
            set(H,'MarkerFaceColor',color);
        else
            set(H,'MarkerFaceColor','flat','FaceVertexCData',color);
        end
    case 'segment'
        if ischar(color)
            set(H,'Marker','x','MarkerEdgeColor','k','MarkerSize',5);
            set(H,'EdgeColor',color,'LineWidth',2);
        else
            color2 = zeros(mesh.nvtx,1);
            for i = 1:mesh.nelt % In this loop : assign to each vertex the color 
            % of one associated segment that it touches. Some will be
            % coloured several times but at least every one gets a color
            % consistent with one element it touches.
                color2(mesh.elt(i,1)) = color(i);
                color2(mesh.elt(i,2)) = color(i);
            end
            set(H,'EdgeColor','flat','FaceVertexCData',color2,'LineWidth',2);
            set(H,'Marker','x','MarkerEdgeColor','k','MarkerFaceColor','none','MarkerSize',5);
        end
        
    case 'triangle'
        if ischar(color)
            set(H,'Marker','.','MarkerFaceColor','k','EdgeColor','k','FaceColor',color)
        else
            set(H,'FaceVertexCData',color,'FaceColor','flat');
            set(H,'Marker','.');
        end
        
    case 'tetrahedron'
        
        m = mesh.bnd; % as we cannot se the interior...
        color2 = zeros(m.nelt,1);
        
        for i = 1:mesh.nelt % In this loop : assign to each face the color 
            % of one associated tetrahedron that it touches. Faces will be
            % coloured several times but at least every one gets a color in
            % the end.
            if ischar(color)
                delete(H);
                plot(m,color);    
            else
                plot(m);
            end
        end
end

return

end
