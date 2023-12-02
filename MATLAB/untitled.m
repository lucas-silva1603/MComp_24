% Example nodal coordinates (replace with your actual coordinates)
nodes = [0, 0; 1, 0; 1, 1; 0, 1];

% Example element connectivity for triangles (replace with your actual connectivity)
elements = [1, 2, 3; 3, 4, 1];

% Example result values (replace with your actual results)
results = [1; 2; 3; 4];

% Plotting the mesh with colored results
figure;
patch('Faces', elements, 'Vertices', nodes, 'FaceVertexCData', results, 'FaceColor', 'interp', 'EdgeColor', 'k');
title('FEM Result Visualization in 2D');
xlabel('X');
ylabel('Y');
colorbar;  % Display color legend