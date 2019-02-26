function [newData,newY]=shuffle(Data,Y)
R=randperm(size(Data,1));
newData=Data(R,:);
newY=Y(R);

end