RMS_d=[];
RMS_r=[];
for i=1:17
[RMS_displacement,RMS_rot]=findRMSDisplacementRotation(fitpars{i,4});
RMS_d=[RMS_d;RMS_displacement];
RMS_r=[RMS_r;RMS_rot];
end

mean(RMS_d)
std(RMS_d)
mean(RMS_r)
std(RMS_r)