function [image_simMotion,fitpars]=addMotionArtifactToMRI(image_original,noiseBasePars,maxDisp,maxRot,show)
%% Normalization and convert to K-Space
% normalize:
image_original=double(image_original);
image_original = image_original / percentile(abs(image_original),95);
rawData = fft3s(image_original);
nT = size(rawData,2);

%% Motion artifact Parameter
% rng(1); % Set the seed for the random number generator to be able to create reproducible motion patterns
% for Perlin noise, this determines the weights between different harmonics of noise
% noiseBasePars = 1; %% *really* rough motion
% noiseBasePars = 5;  %% quite 'rough' motion
% noiseBasePars = 3.^[0:8]; %% smoother motion
% maxDisp = 4; % magnitude of general background noise movement - translations
% maxRot = 4; % magnitude of rotations
swallowFrequency = 3; % number of swallowing events in scan
swallowMagnitude = [3 3]; % first is translations, second is rotations
suddenFrequency = 5; % number of sudden movements
suddenMagnitude = [3 3]; % first is translations, second is rotations
% general background noise movement:
fitpars = zeros(6,nT);
fitpars(1,:) = maxDisp*(perlinNoise1D(nT,noiseBasePars).'-.5)+rand;
fitpars(2,:) = maxDisp*(perlinNoise1D(nT,noiseBasePars).'-.5)+rand;
fitpars(3,:) = maxDisp*(perlinNoise1D(nT,noiseBasePars).'-.5)+rand;
fitpars(4,:) = maxRot*(perlinNoise1D(nT,noiseBasePars).'-.5)+rand;
fitpars(5,:) = maxRot*(perlinNoise1D(nT,noiseBasePars).'-.5)+rand;
fitpars(6,:) = maxRot*(perlinNoise1D(nT,noiseBasePars).'-.5)+rand;

% add in swallowing-like movements - just to z direction and pitch:
swallowTraceBase = exp(-linspace(0,1e2,nT));
swallowTrace = zeros(1,nT);
for iS = 1:swallowFrequency
    swallowTrace = swallowTrace + circshift(swallowTraceBase,[0 round(rand*nT)]);
end
fitpars(3,:) = fitpars(3,:) + swallowMagnitude(1)*swallowTrace;
fitpars(4,:) = fitpars(4,:) + swallowMagnitude(2)*swallowTrace;

% add in random sudden movements in any direction:
suddenTrace = zeros(size(fitpars));
for iS = 1:suddenFrequency
    iT_sudden = ceil(rand*nT);
    suddenTrace(:,iT_sudden:end) = bsxfun(@plus,suddenTrace(:,iT_sudden:end),[suddenMagnitude(1)*((2*rand(3,1))-1); suddenMagnitude(2)*((2*rand(3,1))-1)]);
end
fitpars = fitpars+suddenTrace;

%%% uncomment these lines to just have one big rotation
% fitpars = zeros(size(fitpars));
% fitpars(6,1:100) = 15;
%%% <-- single rotation only

fitpars = bsxfun(@minus,fitpars,fitpars(:,round(nT/2)));

figure(1)
clf
subplot1(2,1,'Gap',[0 .09],'Max',[.95 1])
s1 = subplot1(1); s2 = subplot1(2);
plotFitPars(fitpars,[],[],[],[s1 s2]);
%% Simulate the motion artifact with pre-defined parameters
% convert the motion parameters into a set off affine matrices:
fitMats = euler2rmat(fitpars(4:6,:));
fitMats(1:3,4,:) = fitpars(1:3,:);
% set some things for the recon function:
alignDim = 2; alignIndices = 1:nT; Hxyz = size(rawData); kspaceCentre_xyz = floor(Hxyz/2)+1;
hostVoxDim_mm = [1 1 1];
% use the recon function just to extract the nufft 'object' st:
[~, st] = applyRetroMC_nufft(rawData,fitMats,alignDim,alignIndices,11,hostVoxDim_mm,Hxyz,kspaceCentre_xyz,-1);
% and use the nufft rather than the nufft_adj function to simulate the rotations:
image_simRotOnly = ifft3s(reshape(nufft(ifft3s(rawData),st),size(rawData)));
% then apply just the translations:
[~,~,image_simMotion] = applyRetroMC_nufft(fft3s(image_simRotOnly),fitMats,alignDim,alignIndices,11,hostVoxDim_mm,Hxyz,kspaceCentre_xyz,-1);

image_simMotion = ifft3s(image_simMotion);
image_simMotion = image_simMotion / percentile(abs(image_simMotion),95);

if show==1
    % Load both images in a 3D viewer:
    SliceBrowser2(cat(4,abs(image_original),abs(image_simMotion)),[0 1.5],{'Original image','Simulated motion'})
    set(gcf,'Name','Original image (1) vs Simulated Motion (2)')
end

end