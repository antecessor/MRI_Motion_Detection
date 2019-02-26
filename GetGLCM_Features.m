function Features=GetGLCM_Features(glcm,uy,ux)
P=glcm/sum(glcm(:));
Px=sum(P);
Py=sum(P,2);
P_xy=P(:);
Features=[];
stats = graycoprops(glcm);

Contrast=stats.Contrast;
Features=[Features Contrast];
Corr=stats.Correlation;
Features=[Features Corr];
Energy=stats.Energy;
Features=[Features Energy];
Homo=stats.Homogeneity;
Features=[Features Homo];

AutoCorr=0;
PROM=0;
Shade=0;
Entr=0;
IDM=0;
IMoC1=0;
IMoC2=0;
% Max Prob
val=max(P(:));
[MaxProbi,MaxProbj]=find(P==val);
Features=[Features MaxProbi MaxProbj val];
%
sumSqVar=0;
for i=1:size(glcm,1)
   
    for j=1:size(glcm,2)
        AutoCorr=AutoCorr+i*j*P(i,j);
        PROM=PROM+(i+j-ux-uy).^4*P(i,j);
        Shade=Shade+(i+j-ux-uy).^3*P(i,j);
        check=log(P(i,j));
        if check==-inf
            check=0;
        end
        Entr=Entr+P(i,j)*check;
        IDM=IDM+P(i,j)/(1+(i-j).^2);
        check2=log(Px(i)*Py(j));
        if check2==-inf
            check2=0;
        end
        IMoC1=IMoC1- P(i,j)*check+check2;
        IMoC2=IMoC2- Px(i)*Py(j)*check2+P(i,j)*check;
        sumSqVar=sumSqVar+(i-ux)^2*P(i,j);
    end
end

Entr=-1*Entr;
Features=[Features Entr];
IMoC1=IMoC1/max([sum(Px),sum(Py)]);
Features=[Features IMoC1];
IMoC2=sqrt(1-exp(-2*IMoC2));
Features=[Features IMoC2];

Aver=0;
sumEntro=0;
sumVar=0;
for i=1:numel(P_xy)
    Aver=Aver+i*P_xy(i);
    if log(P_xy(i))==0
       check=0; 
    end
    sumEntro=sumEntro-P_xy(i)*check;
    sumVar=sumVar+i^2*P_xy(i);
end
Features=[Features Aver];
Features=[Features sumEntro];
Features=[Features sumVar];

DiffEnt=0;
DiffVar=0;
for i=1:size(glcm,1)
    if log(P_xy(i))==0
       check=0; 
    end
    DiffEnt=DiffEnt-check*P_xy(i);
    DiffVar=DiffVar+i^2*P_xy(i);
end
Features=[Features DiffEnt];
Features=[Features DiffVar];

end