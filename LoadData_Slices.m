function OutIm=LoadData_Slices()
cd('../Data')

%% NormalData
k=1;
for i=1:18
    Name=['IBSR_' num2str(i,'%2.2i')];
    Imgtemp = uint8(analyze75read([Name '/images/analyze/' Name '_ana']));
    for j=1:size(Imgtemp,3)
        Img{k}=Imgtemp(:,:,j);
        k=k+1;
    end
    
end
%% File 126
files=dir('./126/*.img');
for i=1:numel(files)
    try
        fid = fopen(['126/' files(i).name]);
        I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
        I=uint8(I/max(I(:))*255);
        Img{k}=I;
        k=k+1;
        fclose(fid);
    catch
        break;
    end
end
%% File 536
folder={'536_32','536_45','536_47','536_68','536_88'};
for j=1:numel(folder)
    files=dir(['./536/' folder{j} '/*.img']);
    for i=1:numel(files)
        try
            fid = fopen(['./536/' folder{j} '/' files(i).name]);
            I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
         
            I=uint8(I/max(I(:))*255);
            Img{k}=I;
            k=k+1;
            fclose(fid);
        catch
            break;
        end
    end
end
%% Khan Prof, Images (20Normals_T1)
%% File 657
files=dir('./657_img/*.img');
for i=1:numel(files)
    try
        fid = fopen(['./657_img/' files(i).name]);
        I = double(fread(fid, [256 256], '*int16','b')); %% Big Endian
        I=uint8(I/max(I(:))*255);
        Img{k}=I;
        k=k+1;
        fclose(fid);
    catch
        break;
    end
end
%% File 788
files=dir('./788_6.img/*.img');
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
%% Clean uncorrect loaded
OutIm={};
k=1;
for i=1:numel(Img)
   if size(Img{i},2)>20
        OutIm{k}=Img{i};
        k=k+1;
   end
end

cd('../MatlabCode')