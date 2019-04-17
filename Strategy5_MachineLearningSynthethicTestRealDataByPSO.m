global NFE;
NFE=0;
I_person=LoadData_Slices();
CostFunction=@(x) CostProblem(x,I_person,I,Target);    % Cost Function

nVar=8;             % Number of Decision Variables

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=0;         % Lower Bound of Variables
VarMax=2;          % Upper Bound of Variables


%% PSO Parameters

MaxIt=40;          % Maximum Number of Iterations

nPop=15;            % Population Size (Swarm Size)

w=1;                % Inertia Weight
wdamp=0.99;         % Inertia Weight Damping Ratio
c1=2;               % Personal Learning Coefficient
c2=2;               % Global Learning Coefficient

% % Constriction Coefficient
% phi1=2.05;
% phi2=2.05;
% phi=phi1+phi2;
% chi=2/(phi-2+sqrt(phi^2-4*phi));
% w=chi;               % Inertia Weight
% wdamp=1;             % Inertia Weight Damping Ratio
% c1=chi*phi1;         % Personal Learning Coefficient
% c2=chi*phi2;         % Global Learning Coefficient

alpha=0.1;
VelMax=alpha*(VarMax-VarMin);    % Maximum Velocity
VelMin=-VelMax;                 % Minimum Velocity

%% Initialization

% Create Empty Particle Structure
empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.out=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.out=[];

% Initialize Global Best
GlobalBest.Cost=inf;

% Create Particles Matrix
particle=repmat(empty_particle,nPop,1);

% Initialization Loop
for i=1:nPop
    
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    [particle(i).Cost,particle(i).out]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;
        
    end
    
end

% Array to Hold Best Cost Values at Each Iteration
BestCost=zeros(MaxIt,1);

% Array to Hold NFEs
nfe=zeros(MaxIt,1);

%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            + c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            + c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Update Velocity Bounds
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(OutOfTheRange)=-particle(i).Velocity(OutOfTheRange);
        
        % Update Position Bounds
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        [particle(i).Cost,particle(i).out]=CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.out= particle(i).out;
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                GlobalBest=particle(i).Best;
            end
            
        end
        
        
    end
    
    % Update Best Cost Ever Found
    BestCost(it)=GlobalBest.Cost;
    
    % Update NFE
    nfe(it)=NFE;

    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
    % Inertia Weight Damping
    w=w*wdamp;
    
end

