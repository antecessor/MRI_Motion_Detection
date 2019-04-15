function [RMS_displacement,RMS_rot]=findRMSDisplacementRotation(fitPars)

displacements = sqrt(sum(fitPars(1:3,:).^2,1));
RMS_displacement = sqrt(mean(displacements.^2));

rotations = sqrt(sum(fitPars(4:6,:).^2,1));
RMS_rot = sqrt(mean(rotations.^2));


end