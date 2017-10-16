function [Structure,Acoustic,Interface]=SetupProblem(file_name)
  
eval(file_name); %load file varibles

%elements: structural elements
%coordinates: structural coordinates
%props:structural property
%pload:point load  

%elementa: acoustic elements
%coordinatea: acoustic coordinates
%propa:acoustic property
  
%elementi: interface elements;

%bounds:displacmenet boundary conditions(fixed)
%bounda:point pressure

Structure = struct('elements',elements,'coordinates',coordinates,...
                   'props',props,'pload', pload);
Acoustic  = struct('elementa',elementa,'coordinatea',coordinatea,
                   'propa',propa,'aload',aload);
Interface =struct('elementi', elementi);

Boundary=struct('bounds', bounds, 'bounda', bounda);
end

%__________________________________________________________________________
function [Interface]=NeighborSearch(Structure,Acoustic,Interface)
  
%Extract boundary info
[Bfaces]=MakeBoundary(Structure.elements);
[Bfacea]=MakeBoundary(Acoustic.elementa);

%bucket sort implementation

end

%__________________________________________________________________________
function [Bface]=MakeBoundary(Element)

nelem=size(Element,1);
face=zeros(6,4);
Tface=[];
for i=1:nelem
  EConn= Element(i,:);   % Elem. connectivity          
  face(1,:)=[EConn(1),EConn(2),EConn(3),EConn(4)];
  face(2,:)=[EConn(5),EConn(6),EConn(7),EConn(8)];
  face(3,:)=[EConn(2),EConn(4),EConn(8),EConn(6)];
  face(4,:)=[EConn(4),EConn(3),EConn(7),EConn(8)];
  face(5,:)=[EConn(3),EConn(1),EConn(5),EConn(7)];
  face(6,:)=[EConn(1),EConn(2),EConn(6),EConn(5)];
  
  for j=1:6
    facek=sort(face(j,:));
    if (size(Tface,1)==0) ;
      Tface=[Tface; facek,i,j,0]; %face number(sorted),mother-element,face-order,face-counter
      continue;
    end
    row=find(Tface(:,1)==facek(1));
    if (size(row,1)==0)  %new surface
      Tface=[Tface; facek,i,j,0];
      continue;
    endif
    row1=find(Tface(row,2)==facek(2));
    if (size(row1,1)==0) %new surface
      Tface=[Tface; facek,i,j,0];
      continue;
    endif
    row2=find(Tface(row(row1),3)==facek(3));
    if (size(row2,1)==0) %new surface
      Tface=[Tface; facek,i,j,0];
      continue;
    endif
    row3=find(Tface(row(row1(row2)),4)==facek(4));
    if (size(row3,1)==0) %new surface
      Tface=[Tface; facek,i,j,0];
      continue;
    endif
    idx=row(row1(row2(row3(1)))); %exist surface 
    Tface(idx,7)+=1;    
  end
end
  
nf=size(Tface,1);
Bface=[];
for k=1:nf
  if ((Tface(k,7))==0) 
    Bface=[Bface; Tface(k,1:6)]; %extract boundary
  endif
end

nbf=size(Bface,1);
for k=1:nbf
  EConn=Element(Tface(k,5),:);   % Elem. connectivity    
  fidx=Tface(k,6);                % Face idx 1~6
  if (fidx==1)     face=[EConn(1),EConn(2),EConn(3),EConn(4)];
  elseif (fidx==2) face=[EConn(5),EConn(6),EConn(7),EConn(8)];
  elseif (fidx==3) face=[EConn(2),EConn(4),EConn(8),EConn(6)];
  elseif (fidx==4) face=[EConn(4),EConn(3),EConn(7),EConn(8)];
  elseif (fidx==5) face=[EConn(3),EConn(1),EConn(5),EConn(7)];
  elseif (fidx==6) face=[EConn(1),EConn(2),EConn(6),EConn(5)];
  end
  Bface(k,1:4)=face;  
end

end

