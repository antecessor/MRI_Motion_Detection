function fis=FuzzyAnfisDeepLearning(TrainInputs,TrainTargets)

TrainData=[TrainInputs TrainTargets];
%% Design ANFIS
Option{1}='Grid Part. (genfis1)';
Option{2}='Sub. Clustering (genfis2)';
Option{3}='FCM (genfis3)';

% ANSWER=questdlg('Select FIS Generation Approach:',...
%                 'Select GENFIS',...
%                 Option{1},Option{2},Option{3},...
%                 Option{3});
ANSWER=Option{3};
switch ANSWER
    case Option{1}
        Prompt={'Number of MFs','Input MF Type:','Output MF Type:'};
        Title='Enter genfis1 parameters';
        DefaultValues={'5','gaussmf','linear'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        
        nMFs=str2num(PARAMS{1}); %#ok
        InputMF=PARAMS{2};
        OutputMF=PARAMS{3};
        
        fis=genfis1(TrainData,nMFs,InputMF,OutputMF);

    case Option{2}
        Prompt={'Influence Radius:'};
        Title='Enter genfis2 parameters';
        DefaultValues={'0.2'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        
        Radius=str2num(PARAMS{1}); %#ok
        
        fis=genfis2(TrainInputs,TrainTargets,Radius);
        
    case Option{3}
        Prompt={'Number fo Clusters:',...
                'Partition Matrix Exponent:',...
                'Maximum Number of Iterations:',...
                'Minimum Improvemnet:'};
        Title='Enter genfis3 parameters';
        DefaultValues={'10','2','100','1e-5'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        
        nCluster=str2num(PARAMS{1}); %#ok
        Exponent=str2num(PARAMS{2}); %#ok
        MaxIt=str2num(PARAMS{3}); %#ok
        MinImprovment=str2num(PARAMS{4}); %#ok
        DisplayInfo=1;
        FCMOptions=[Exponent MaxIt MinImprovment DisplayInfo];
        
        fis=genfis3(TrainInputs,TrainTargets','sugeno',nCluster,FCMOptions);
end

Prompt={'Maximum Number of Epochs:',...
        'Error Goal:',...
        'Initial Step Size:',...
        'Step Size Decrease Rate:',...
        'Step Size Increase Rate:'};
Title='Enter genfis3 parameters';
DefaultValues={'100','0','0.01','0.9','1.1'};

PARAMS=inputdlg(Prompt,Title,1,DefaultValues);


MaxEpoch=str2num(PARAMS{1});                %#ok
ErrorGoal=str2num(PARAMS{2});               %#ok
InitialStepSize=str2num(PARAMS{3});         %#ok
StepSizeDecreaseRate=str2num(PARAMS{4});    %#ok
StepSizeIncreaseRate=str2num(PARAMS{5});    %#ok
TrainOptions=[MaxEpoch ...
              ErrorGoal ...
              InitialStepSize ...
              StepSizeDecreaseRate ...
              StepSizeIncreaseRate];

DisplayInfo=true;
DisplayError=true;
DisplayStepSize=true;
DisplayFinalResult=true;
DisplayOptions=[DisplayInfo ...
                DisplayError ...
                DisplayStepSize ...
                DisplayFinalResult];

OptimizationMethod=1;
% 0: Backpropagation
% 1: Hybrid
            
fis=anfis(TrainData,fis,TrainOptions,DisplayOptions,[],OptimizationMethod);


%% Apply ANFIS to Train Data
% TrainOutputs=evalfis(TrainInputs,fis);


end