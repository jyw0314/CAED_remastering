function [Kmat,Mmat,Fvec]=BuildAcousticProblem(EGeometry,Acoustic)
  
% Element,node info from Acoustic
Elementa = Acoustic.elementa; 
Coordinatea = Acoustic.coordinatea; 
Propa = Acoustic.propa; 
Aload = Acoustic.aload;

% Find basic dimensions
nnode = size(Coordinatea,1);        % Number of nodes
nndof = nnode;                       % Number of total DOF
nelem = size(Elementa,1);            % Number of elements

% Dimension the global matrices
Kmat  = sparse( nndof , nndof );  % Create the global stiffness matrix
Mmat  = sparse( nndof , nndof );      % Create the global Mass matrix
Fvec  = sparse( nndof , 1 );      % Create the global force vector

% Assemble system matrix
for k = 1 : nelem
  EConn= Elementa(k,:);                                 % Elem. connectivity
  ECoord(1:8,:) = Coordinatea(EConn(1:8),:);            % Elem. coordinates                                 
  [Ke,Me]=ComputeElementMatrixa(EGeometry,ECoord,Propa);
  
  % Assemble the mass matrix and the stiffness matrix
  Kmat(EConn,EConn)+=Ke;
  Mmat(EConn,EConn)+=Me;
end

npload=size(Aload,1);
for k= 1 : npload
  Fvec(Aload(k,1))+=Aload(k,2);
end

  
end

%__________________________________________________________________________
function [Ke,Me] = ComputeElementMatrixa(EGeometry,Coord,prop)

% Shape, Integration info from Egeometry
Weightv = EGeometry.Weightv; 
N = EGeometry.N;
Nd = EGeometry.Nd;

ntdeg=length(Weightv);
c0=prop(1,1);
co1=1./power(c0,2);

B=zeros(1,8);
J=zeros(3,3);
deriv=zeros(3,8);

Ke=zeros(8,8);
Me=zeros(8,8);
for k=1:ntdeg
  J=Nd([3*k-2:3*k],:)*Coord;
  dVol=det(J)*Weightv(k);
  deriv=inv(J)*Nd([3*k-2:3*k],:);
  B=Build_Ba(B,deriv);
  Ke= Ke + (B'*B*dVol);
  Me=Build_Ma(Me,N,co1,dVol,k);
end
end
%__________________________________________________________________________
function [M] = Build_Ma(M,N,c0,dVol,idx)
for k=1:8
  for j=1:8
    matk=1./power(c0,2)*N(idx,k)*N(idx,j)*dVol;
    M(k,j)+=matk;
  end
end

end
%__________________________________________________________________________
function [B] = Build_Ba(B,deriv)
for k=1:8
  B(1,k)=deriv(1,k); 
  B(2,k)=deriv(2,k); 
  B(3,k)=deriv(3,k); 
end;
end

