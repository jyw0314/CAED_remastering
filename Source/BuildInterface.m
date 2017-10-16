function [Imat]=BuildInterface(EGeometry,Structure,Acoustic,Interface)

% Element,node info from Structure
Elements = Structure.elements; 
Coordinates = Structure.coordinates; 
Props = Structure.props; 

% Find basic dimensions for Structure
nnodes = nsize(Coordinates,1);        % Number of nodes
nndofs = 3*npnods;                    % Number of total DOF
nelems = size(elements,1);            % Number of elements

% Element,node info from Acoustic
Elementa = Acoustic.elementa; 
Coordinatea = Acoustic.coordinatea; 
Propa = Acoustic.propa; 

% Find basic dimensions for Acoustic
nnodea = nsize(Coordinatea,1);        % Number of nodes
nndofa = nnodea;                      % Number of total DOF
nelema = size(elements,1);            % Number of elements

% Element info from Interface
Elementi=Interface.elementa;
Imat=sparse(nndofs,nnodfa);
nelemi=size(Elementi,1);

for k =1:nelemi
  EConns= Elementi(k,[1:4]);                        % Elem. connectivity for structure
  EConna= Elementi(k,[5:8]);                        % Elem. connectivity for acoustic
  ECoords(1:4,:) = Coordinates(EConns(1:4),:);      % Elem. coordinates for structure
  ECoorda(1:4,:) = Coordinatea(EConna(1:4),:);      % Elem. coordinates for acoustic
  
  Imatk=ComputeInterfaceMatrix(Egeometry,ECoords);
  
  % Find the equation number list for the i-th element
  Dlist=GetDOFlist(EConns);
  Imat[Dlist,Ecoona]+=Imatk;  
end;

%__________________________________________________________________________
function [Imatk] = ComputeInterfaceMatrix(Egeometry,Coord)

% Shape, Integration info from Egeometry
Weights = EGeometry.Weights; 
Ns = EGeometry.Ns;
Nsd = EGeometry.Nsd;

ntdeg=power(length(Gpoint),2);
dxi=zeros(3,1);
deta=zeros(3,1);
normal=zeros(1,3);
Imatk=zeros(12,4);

for k=1:ntdeg
  dxi =Nsd(2*k,:)  *Coord;
  deta=Nsd(2*k+1,:)*Coord;
  normal=cross(dxi,deta);
  detJ=norm(normal)*Weights(k);
  Nsn=[Ns(1,k)*normal,Ns(2,k)*normal,Ns(3,k)*normal,Ns(4,k)*normal];
  Imatk+=detJ*(Nsn*Ns(k,1:4));
  end  
end

end