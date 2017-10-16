clear all

file_name = input('Enter the file name: ','s');

tic;                   % Start clock
ttim = 0;              % Initialize time counter

EGeometry= SetupElementGeometry();
[Structure,Acoustic,Interface,Boundary]=SetupProblem(file_name); 
ttim = timing('Read Information',ttim); %Reporting time

% Construct structural mechanic problem
[Kmats,Mmats,Fvecs]=BuildStructureProblem(EGeometry,Structure)
ttim = timing('Build Structure problem',ttim); %Reporting time

% Construct acoustic problem
[Kmata,Mmata,Fveca]=BuildAcousticProblem(EGeometry,Acoustic)
ttim = timing('Build Structure problem',ttim); %Reporting time

% Construct interface problem
[Imat]=BuildAcousticProblem(EGeometry,Structure,Acoustic,Interface)
ttim = timing('Build Interface problem',ttim); %Reporting time

% Build structural-acoustic matrix
[KC,MC,Fc]=BuildGlobalMatrix(Kmats,Mmats,Fvecs,Kmata,Mmata,Fveca,Boundary);
ttim = timing('Build Global matrix and Apply BC',ttim); %Reporting time

%Solving eigenvalue problem
[Phi,Omega]=eig(KC,MC);
ttim = timing('Solve EigenValue problem',ttim); %Reporting time












