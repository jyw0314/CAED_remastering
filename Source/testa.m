function [u]=testa()
file_name = input('Enter the file name: ','s');
eval(file_name); %load file varibles

Acoustic  = struct('elementa',elementa,'coordinatea',coordinatea,
                   'propa',propa,'aload',aload);
Boundary=struct('bounds', bounds, 'bounda', bounda);
EGeometry= SetupElementGeometry();

% Construct structural mechanic problem
[Kmata,Mmata,Fveca]=BuildAcousticProblem(EGeometry,Acoustic);

% Apply the Dirichlet conditions for structural problem
Bounda=Boundary.bounda;
nb=size(Bounda,1);
nndof=size(Kmata,1);
u=sparse( nndof, 1 );
fix=sparse(nb,1);

for i = 1 : nb
  ieqn = Bounda(i,1);               % Find the equation number
  u(ieqn)= Bounda(i,2);                 % and store the solution in u
  fix(i) = ieqn;                        % and mark the eq. as a fix value
end

Fveca-= Kmata* u;      % Adjust the rhs with the known values
FreeNodea = setdiff(1:nndof,fix);           % Find the free node list and
u(FreeNodea) = Kmata(FreeNodea,FreeNodea) \ Fveca(FreeNodea);    


end