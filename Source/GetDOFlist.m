function [Dlist] = GetDOFlist(Ecoon)

nn=length(Ecoon);
Dlist=zeros(1,nn*3);
for k=1:nn
  Dlist(1,[3*k-2:3*k])=[3*Ecoon(k)-2:3*Ecoon(k)];
end
end