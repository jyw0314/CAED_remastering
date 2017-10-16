function [u]=tests()
file_name = input('Enter the file name: ','s');
eval(file_name); %load file varibles

Structure = struct('elements',elements,'coordinates',coordinates,...
                   'props',props,'pload', pload);
Boundary=struct('bounds', bounds, 'bounda', bounda);
EGeometry= SetupElementGeometry();

% Construct structural mechanic problem
[Kmats,Mmats,Fvecs]=BuildStructureProblem(EGeometry,Structure);

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

u(FreeNodes) = Kmats(FreeNodes,FreeNodes) \ Fvecs(FreeNodes);    


end


