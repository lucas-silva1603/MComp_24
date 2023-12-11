figure(1);
title('Potencial em 2D');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor

    % Desenho do potencial
patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', uex, 'FaceColor', 'interp', 'EdgeColor', 'k');hold on

    % Desenho dos nós
plot(x,y,'ro');
