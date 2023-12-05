% Assuming you have an array of pressures for each element
% Replace this with your actual pressure data
pressures = [10, 20, 30, 15, 25];

% Assuming you have the connectivity table
% Replace this with your actual connectivity table
connectivity = [
    1, 2, 3, 4;
    % Add more rows for additional elements
];

% Assuming you have the x and y vectors
% Replace this with your actual x and y vectors
x = [0, 1, 1, 0];
y = [0, 0, 1, 1];

% Create a figure
figure;

% Plot elements and color them according to pressure
for i = 1:size(connectivity, 1)
    element_nodes = connectivity(i, :);
    element_x = x(element_nodes);
    element_y = y(element_nodes);
    
    % Use the patch function to create a polygon for each element
    patch(element_x, element_y, pressures(i), 'EdgeColor', 'k');
end

% Set colorbar
colorbar;

% Set axis labels as needed
xlabel('X-axis');
ylabel('Y-axis');
title('Pressure Distribution in Elements');
