% Assuming you have Kg, Fg, and U_fixed defined
U_fixed = zeros(7, 1);
U_fixed(4) = 3;
U_fixed(1) = 2;

% Set up the modified stiffness matrix
Kg_modified = Kg;
fg_modified = fg;

% Enforce values at specified nodes in the force vector
fg_modified(U_fixed) = U_fixed(U_fixed);

% Set fixed values in the modified stiffness matrix
Kg_modified(U_fixed, :) = 0;
Kg_modified(:, U_fixed) = 0;
Kg_modified(U_fixed, U_fixed) = eye(length(U_fixed));

% Solve the modified system using pcg
tolerance = 1e-6;
maxIterations = 1000;
preconditioner = ichol(Kg_modified);

[Ug, flag, relres, iter, resvec] = pcg(Kg_modified, fg_modified, tolerance, maxIterations, preconditioner);