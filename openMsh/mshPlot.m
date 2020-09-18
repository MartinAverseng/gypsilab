function mshPlot(mesh)


color = mesh.col;

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
            for i = 1:mesh.nelt
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
        
        [m,elt2fce] = mesh.fce; 
        color2 = zeros(m.nelt,1);
        for i = 1:mesh.nelt
            color2(elt2fce(i,1),1) = color(i);
            color2(elt2fce(i,2),1) = color(i);
            color2(elt2fce(i,3),1) = color(i);
            color2(elt2fce(i,4),1) = color(i);
        end
        m.col = color2;
        plot(m);     
end

return

end
