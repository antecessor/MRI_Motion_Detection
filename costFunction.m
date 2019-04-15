function z=costFunction(x,In,fis,target,u,Important)
global TeoryOne

x(1)=1;
x(8)=1;
% x(14)=1;
In=x.*In;
% sum(x(8:12))
In=CheckRange(In);
% In=ComputeRelations(In);

Out=evalfis(In,fis);
importantPrecision=100;
% Important=ComputeRelations(Important);
WeightBott=abs(u-sum(In(2:6)));

DifferentTeoryAndCalc=sum(abs(TeoryOne-In));
CostFirst=sum(Important.*TeoryOne);
Cost=sum(Important.*In);
z=importantPrecision*abs(Out-target)+3*Cost+.5*DifferentTeoryAndCalc;
if CostFirst<=Cost
z=inf;
end
if In(5)<2;
 z=inf;
end
if WeightBott>100
    z=inf;
end
CA=In(2);
CF=In(3);
P=In(4);
C=In(5);
W=In(6);
Air=In(7);
MSA=In(8);
if W/(C+P)<.19 || W/(C+P)>1.67
    z=inf;
end
if P/(C+P)<.01 || P/(C+P)>.7
    z=inf;
end
end