function [Fvecs,FreeNodes,Fveca,FreeNodea]=ApplyBC(Kmats,Fvecs,Kmata,Fveca,Boundary)
% Apply the Dirichlet conditions for structural problem
Bounds=Boundary.bounds;
nb=size(Bounds,1);
nndof=size(Kmats,1);
u=sparse( nndof, 1 );
fix=sparse(nb,1);

for i = 1 : nb
  ieqn = (Bounds(i,1)-1)*3 + Bounds(i,2);  % Find the equation number
  u(ieqn)= Bounds(i,3);                 % and store the solution in u
  fix(i) = ieqn;                        % and mark the eq. as a fix value
end

Fvecs-= Kmats* u;      % Adjust the rhs with the known values
FreeNodes = setdiff(1:nndof,fix);           % Find the free node list and

% Apply the Dirichlet conditions for acoustic problem
Bounda=Boundary.bounda;
nb=size(Bounda,1);
nndof=size(Kmata,1);
u=sparse( nndof, 1 );
fix=sparse(nb,1);

for i = 1 : nb
  ieqn = Bounda(i,1);               % Find the equation number
  u(ieqn)= Bounds(i,32;                 % and store the solution in u
  fix(i) = ieqn;                        % and mark the eq. as a fix value
end

Fveca-= Kmata* u;      % Adjust the rhs with the known values
FreeNodea = setdiff(1:nndof,fix);           % Find the free node list and
end
