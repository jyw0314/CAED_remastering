function [Kmat,Mmat,Fvec]=BuildStructureProblem(EGeometry,Structure)

% Element,node info from Structure
Elements = Structure.elements; 
Coordinates = Structure.coordinates; 
Props = Structure.props; 
Pload = Structure.pload;

% Find basic dimensions
nnode = size(Coordinates,1);        % Number of nodes
nndof = 3*nnode;                     % Number of total DOF
nelem = size(Elements,1);            % Number of elements

% Dimension the global matrices
Kmat  = sparse( nndof , nndof );  % Create the global stiffness matrix
Mmat  = sparse( nndof , nndof );      % Create the global Mass matrix
Fvec  = sparse( nndof , 1 );      % Create the global force vector

% Assemble system matrix
for k = 1 : nelem
  EConn= Elements(k,:);                         % Elem. connectivity
  ECoord(1:8,:) = Coordinates(EConn(1:8),:);    % Elem. coordinates
  Eprop=Props(k,:);                             % Elem. property
  [Ke,Me]=ComputeElementMatrixs(EGeometry,ECoord,Eprop);
  
  % Find the equation number list for the i-th element
  Dlist=GetDOFlist(EConn);
  
  % Assemble the mass matrix and the stiffness matrix
  Kmat(Dlist,Dlist)+=Ke;
  Mmat(Dlist,Dlist)+=Me;
end

npload=size(Pload,1);
for k= 1 : npload
  Fvec(3*Pload(k,1)-3+Pload(k,2))+=Pload(k,3);
end

end


%__________________________________________________________________________
function [Ke,Me] = ComputeElementMatrixs(EGeometry,Coord,prop)

% Shape, Integration info from Egeometry
Weightv = EGeometry.Weightv; 
N  = EGeometry.N;
Nd = EGeometry.Nd;

ntdeg=length(Weightv);
rho=prop(1,3);
C=Compute_C(prop);

B=zeros(6,24);
J=zeros(3,3);
deriv=zeros(3,8);

Ke=zeros(24,24);
Me=zeros(24,24);

for k=1:ntdeg
  J=Nd([3*k-2:3*k],:)*Coord;
  dVol=det(J)*Weightv(k);
  deriv=inv(J)*Nd([3*k-2:3*k],:);
  B=Build_Bs(B,deriv);
  Ke+=dVol*(B'*C*B);
  Me= Build_Ms(Me,N,dVol,rho,k);
end
end
%__________________________________________________________________________
function [M] = Build_Ms(M,N,dVol,rho,idx)
for k=1:8
  idx1=3*k-2;
  for j=1:8
    idx2=3*j-2;
    matk=rho*N(idx,k)*N(idx,j)*dVol;
    M(idx1,idx2)+=matk;
    M(idx1+1,idx2+1)+=matk;
    M(idx1+2,idx2+2)+=matk;
  end
end

end
%__________________________________________________________________________
function [B] = Build_Bs(B,deriv)
for k=1:8
  idx=3*k-2;
  B(1,idx)=deriv(1,k); B(1,idx+1)=0.; B(1,idx+2)=0.;
  B(2,idx)=0.; B(2,idx+1)=deriv(2,k); B(2,idx+2)=0.;
  B(3,idx)=0.; B(3,idx+1)=0.; B(3,idx+2)=deriv(3,k); 
  B(4,idx)=deriv(2,k); B(4,idx+1)=deriv(1,k); B(4,idx+2)=0.;
  B(5,idx)=deriv(3,k); B(5,idx+1)=0.;  B(5,idx+2)=deriv(1,k); 
  B(6,idx)=0.; B(6,idx+1)=deriv(3,k);  B(6,idx+2)=deriv(2,k); 
end
end

%__________________________________________________________________________
function [C] = Compute_C(prop)
young=prop(1,1); poiss=prop(1,2);
aux1 = young*(1-poiss)/((1+poiss)*(1-2*poiss));
aux2 = aux1*poiss/(1-poiss);
aux3 = aux1*(1-2*poiss)/(2*(1-poiss));
  
C = [   aux1 , aux2, aux2,   0 ,   0 ,   0  ;
         aux2,   aux1 , aux2,   0 ,   0 ,   0  ;
         aux2, aux2,   aux1 ,   0 ,   0 ,   0  ;
           0 ,   0 ,   0 , aux3,   0 ,   0  ;
           0 ,   0 ,   0 ,   0 , aux3,   0  ;
           0 ,   0 ,   0 ,   0 ,   0 , aux3 ];
end