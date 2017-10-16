function [KC,MC,Fc]=BuildGlobalMatrix(Kmats,Mmats,Fvecs,Kmata,Mmata,Fveca,Boundary)

%Apply boundary condition
[Fvecs,FNodes,Fveca,FNodea]=ApplyBC(Kmats,Fvecs,Kmata,Fveca,Boundary);

ns=length(FNodes);
na=length(FNodea);
nt=ns+na;
Propa = Acoustic.propa; 

Kc=sparse(nt,nt);
MC=sparse(nt,nt);
Fc=sparse(nt,1);

KC([1:ns],[1:ns])=      Kmats(FNodes,FNodes);
KC([ns+1:nt],[ns+1:nt])=Kmata(FNodea,FNodea);
KC([1:ns],[ns+1:nt])=  -Imat(FNodes,FNodea);

MC([1:ns],[1:ns])=      Mmats(FNodes,FNodes);
MC([ns+1:nt],[ns+1:nt])=Mmata(FNodea,FNodea);
MC([ns+1:nt],[1:ns])=   Propa(1,2)*Imat(FNodes,FNodea)';

Fc([1:ns])=   Fvecs(FNodes);
Fc([ns+1:nt])=Fvecs(FNodea);
end
