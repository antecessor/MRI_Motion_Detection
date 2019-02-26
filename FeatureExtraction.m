function F=FeatureExtraction(I)

%% Phase stretch transform
handles.LPF=0.21;
handles.Phase_strength=0.48;
handles.Warp_strength=12.14;
handles.Thresh_min=-1;
handles.Thresh_max=0.004;
outPhaseStretch= PST(I,handles,0);
%% Local binary pattern
LBP = double(lbp(I));
%% glcm
ux=2;
uy=2;
glcm = graycomatrix(I,'Offset',[ux uy]);
GLCMFeatures=GetGLCM_Features(glcm,ux,uy);
%% All
F=[GLCMFeatures std(median(LBP)) skewness(median(LBP)) std(median(outPhaseStretch)) skewness(median(outPhaseStretch))];

end