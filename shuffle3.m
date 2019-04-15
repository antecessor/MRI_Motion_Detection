function [newData,newY1,newY2,newY3]=shuffle3(Data,Y1,Y2,Y3)
R=randperm(size(Data,1));
newData=Data(R,:);
newY1=Y1(R);
newY2=Y2(R);
newY3=Y3(R);
end