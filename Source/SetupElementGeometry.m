function EGeometry=SetupElementGeometry()

gpoint = [ -0.577350269189626E+00 ,  0.577350269189626E+00 ];
weight = [  1.0E+00 ,  1.0E+00 ];

[Weightv,Weights]=ComputeWeightVector(weight);
[N,Nd]=ElementGeometry(gpoint);
[Ns,Nsd]=ElementSurfaceGeometry(gpoint);

EGeometry = struct('N',N,'Nd',Nd,...
     'Ns',Ns,'Nsd',Nsd,'Weightv',Weightv,'Weights',Weights);
end
%__________________________________________________________________
function [Weightv,Weights]=ComputeWeightVector(weight)
  
ng=length(weight);
Weights=zeros(power(ng,2),1);
Weightv=zeros(power(ng,3),1);
m=1;
for k=1:ng
  for j=1:ng
    for i=1:ng
      Weightv(m++)=weight(k)*weight(j)*weight(i);
    end
  end
end

m=1;
for k=1:ng
  for j=1:ng
    Weights(m++)=weight(k)*weight(j);
  end
end

end
%__________________________________________________________________
function [N,Nd]=ElementGeometry(gpoint)
%shape function for hexa8
shape = @(s,t,v)[(1-s)*(1-t)*(1-v)/8,(1+s)*(1-t)*(1-v)/8,...
                   (1+s)*(1+t)*(1-v)/8,(1-s)*(1+t)*(1-v)/8,...
                   (1-s)*(1-t)*(1+v)/8,(1+s)*(1-t)*(1+v)/8,...
                   (1+s)*(1+t)*(1+v)/8,(1-s)*(1+t)*(1+v)/8];                     
%shape function deriv for hexa8          
deriv1 = @(s,t,v)[-(1-t)*(1-v)/8, (1-t)*(1-v)/8,...
                    (1+t)*(1-v)/8,-(1+t)*(1-v)/8,...
                   -(1-t)*(1+v)/8, (1-t)*(1+v)/8,...
                    (1+t)*(1+v)/8,-(1+t)*(1+v)/8];
deriv2 = @(s,t,v)[ -(1-s)*(1-v)/8,-(1+s)*(1-v)/8,...
                    (1+s)*(1-v)/8, (1-s)*(1-v)/8,...
                   -(1-s)*(1+v)/8,-(1+s)*(1+v)/8,...
                    (1+s)*(1+v)/8, (1-s)*(1+v)/8];  
deriv3 = @(s,t,v)[  -(1-s)*(1-t)/8,-(1+s)*(1-t)/8,...
                   -(1+s)*(1+t)/8,-(1-s)*(1+t)/8,...
                    (1-s)*(1-t)/8, (1+s)*(1-t)/8,...
                    (1+s)*(1+t)/8, (1-s)*(1+t)/8 ];  

ndeg=length(gpoint);
tndeg=power(ndeg,3);

N=zeros(tndeg,8);
Nd=zeros(tndeg*3,8);

m=1; n=1;
 for i = 1 : ndeg
    for j = 1 : ndeg
      for k = 1 : ndeg
        N(m++,:)=shape(gpoint(i),gpoint(j),gpoint(k)); 
        Nd(n++,:)=deriv1(gpoint(i),gpoint(j),gpoint(k)); 
        Nd(n++,:)=deriv2(gpoint(i),gpoint(j),gpoint(k)); 
        Nd(n++,:)=deriv3(gpoint(i),gpoint(j),gpoint(k)); 
      end
    end
  end

end
%__________________________________________________________________
function [N,Nd]=ElementSurfaceGeometry(gpoint)

%shape function for quad4
shape = @(s,t)[(1-s).*(1-t)/4, (1+s).*(1-t)/4,...
               (1+s).*(1+t)/4, (1-s).*(1+t)/4];                  
%shape function deriv for quad4          
deriv1 = @(s,t)[(t-1)/4, (1-t)/4, (1+t)/4, -(1+t)/4];
deriv2 = @(s,t)[(s-1)/4, -(1+s)/4,   (1+s)/4,  (1-s)/4 ];
         
ndeg=length(gpoint);
tndeg=power(ndeg,2);

N=zeros(tndeg,4);
Nd=zeros(tndeg*2,4);

m=1; n=1;
 for i = 1 : ndeg
    for j = 1 : ndeg
      N(m++,:)=shape(gpoint(i),gpoint(j));
      Nd(n++,:)=deriv1(gpoint(i),gpoint(j)); 
      Nd(n++,:)=deriv2(gpoint(i),gpoint(j));
    end
  end

end