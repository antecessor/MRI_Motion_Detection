function I_person=LoadData_Slices()
cD=pwd;
cd('../Data')
I_person={};
%% NormalData
k=1;
p=1;
for i=1:18
    Img=[];
    Name=['IBSR_' num2str(i,'%2.2i')];
    Imgtemp = uint8(analyze75read([Name '/images/analyze/' Name '_ana']));
    for j=1:size(Imgtemp,3)
        Img(:,:,k)=Imgtemp(:,:,j);
        k=k+1;
    end
    I_person{p}=Img;
    p=p+1;
end
%% File 126
files=dir('./126/*.img');
Img=[];
for i=1:numel(files)
    try
        fid = fopen(['126/' files(i).name]);
        I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
        I=uint8(I/max(I(:))*255);
        Img(:,:,k)=I;
        k=k+1;
        fclose(fid);
    catch
        break;
    end
end
I_person{p}=Img;
p=p+1;
%% File 536
folder={'536_32','536_45','536_47','536_68','536_88'};
for j=1:numel(folder)
    files=dir(['./536/' folder{j} '/*.img']);
    Img=[];
    for i=1:numel(files)
        try
            fid = fopen(['./536/' folder{j} '/' files(i).name]);
            I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
            
            I=uint8(I/max(I(:))*255);
            Img(:,:,k)=I;
            k=k+1;
            fclose(fid);
        catch
            break;
        end
    end
    I_person{p}=Img;
    p=p+1;
end
%% Khan Prof, Images (20Normals_T1)
%% File 657
files=dir('./657_img/*.img');
Img=[];
for i=1:numel(files)
    try
        fid = fopen(['./657_img/' files(i).name]);
        I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
        I=uint8(I/max(I(:))*255);
        Img(:,:,k)=I;
        k=k+1;
        fclose(fid);
    catch
        break;
    end
end
I_person{p}=Img;
p=p+1;
%% File 788
files=dir('./788_6.img/*.img');
Img=[];
for i=1:numel(files)
    try
        fid = fopen(['./788_6.img/' files(i).name]);
        I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
        I=uint8(I/max(I(:))*255);
        Img{k}=I;
        k=k+1;
        fclose(fid);
    catch
        break;
    end
end
I_person{p}=Img;
p=p+1;
%% return to root
cd(cD);