function In=CheckRange(In)
range=zeros(8,2);
range(3,1)=620;range(3,2)=1247;%Fin aggregate(kg)_9
range(4,1)=0;range(4,2)=250;%Pozzolan(kg)_10
range(5,1)=0;range(5,2)=450;%Cement(kg)_11
range(6,1)=25;range(6,2)=250;%Water(kg)_12
range(7,1)=0;range(7,2)=4.5;%Air _13
range(8,1)=9.5;range(8,2)=150;%MSA(mm)_1
if In(8)>130
    range(2,1)=1575;range(2,2)=1600;%Corse aggregate(kg)_8
elseif In(8)>100 && In(8)<=130
        range(2,1)=1525;range(2,2)=1575;%Corse aggregate(kg)_8
elseif In(8)>45 && In(8)<=100
     range(2,1)=125;range(2,2)=1525;%Corse aggregate(kg)_8
elseif  In(8)>25 && In(8)<=45
     range(2,1)=1300;range(2,2)=100;%Corse aggregate(kg)_8
elseif  In(8)>15 && In(8)<=25
    range(2,1)=1150;range(2,2)=1300;%Corse aggregate(kg)_8
elseif  In(8)>=9.8 && In(8)<=15
    range(2,1)=1050;range(2,2)=1200;%Corse aggregate(kg)_8
end

for i=2:size(range,1)
    Range=range(i,:);
    In(i)=min([max([In(i),Range(1)]),Range(2)]);
end
end