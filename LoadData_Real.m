function [I,Target]=LoadData_Real()

Data=xlsread('D:\WorkSpace\MRI_Philips\Data\RealData\motion_artifact_images_UW\motion_artifact_scores.xlsx');
maxInd=962;
Target=Data(1:maxInd,2);
for i=1:maxInd
    I{i}=imread(['D:\WorkSpace\MRI_Philips\Data\RealData\motion_artifact_images_UW\' num2str(i-1) '.png']);
end

end