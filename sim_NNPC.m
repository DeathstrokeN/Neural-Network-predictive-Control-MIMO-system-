%% By Bellila Ahmed Nassim, student at ENST (Algeria)
%On exchange at Université Laval
%Research project under supervision of Prof. André Desbiens
%entity : LOOP (Laboratoire d'optimisation et d'observation des procédés)

%see Readme.txt to understand more the process



clear;
warning off


%% Procédé 

Gd=discrete_ss_plant(3,3);
Tech=Gd.Ts;
A=Gd.A;
B=Gd.B;
C=Gd.C;
D=Gd.D;
Ny=size(C,1);
Nu=size(B,2);
xp=zeros(length(A),1);


%% Structure du NN
name_of_NN_function='myNNc33.m';
copyfile(name_of_NN_function,'NNc.m');
id=2; % voir NNc.m: 2eme dimension de xi1
fd=2; % voir NNc.m: 2eme dimension de ai2

%% Durée de la simulation

N = 100; % Nombre de points à simuler
t=(0:N-1)*Tech; % Vecteur temps


%% Consignes et perturbations de sortie

% Consignes
r=setpoints(3,N);

% Perturbations
d=disturbances(3,N);



%% Paramètres du MPC

Hc = 3; 
Hp = 20;
lambda = [.1 1 .1];
phi = [1 1 1];
lb = -20*ones(Nu,Hc);
ub = 20*ones(Nu,Hc);



%% Initialisation

u = zeros(Nu,Hc);
upast=zeros(Nu,1);
simdata = zeros(Nu+Ny,N);
yIMC=zeros(1,Ny);
xi1 = zeros(Nu,id);
ai2 = zeros(Ny,fd);
exitflag=zeros(1,N);
crit=zeros(1,N);


%% Paramètres d'optimisation

options=optimoptions('fmincon');
options.OptimalityTolerance = 1e-6; 
options.Algorithm = 'interior-point';
options.StepTolerance = 1e-6;
options.Display = 'Off';
options.FunctionTolerance = 1e-6;
options.FiniteDifferenceStepSize = sqrt(eps);


%% Boucle de simulation

for j = 1:N
  
    % Sortie procédé
    y=C*xp + d(:,j);
    
    % Modèle IMC
    [yIMC, xi1, ai2] = NNc(upast,xi1, ai2); 
    
    % Estimation perturbation
    stoch=y-yIMC;
  
    % Commande optimale
    [u,crit(j),exitflag(j)]= fmincon(@(u) evalcritc(u, r(:,j), Hp, Hc, lambda, phi, xi1, ai2, upast, stoch),...
        u,[],[],[],[],lb,ub,[],options);
    upast=u(:,1);

    % États procédé
    xp=A*xp+B*upast;
    
    % Data
    simdata(:,j) = [u(:,1); y]; 
     
end

 
%% Figures

figure(2);
subplot(211);
plot(t,simdata(1:Nu,:))
legend('u1','u2','u3')
title('Variables manipulées')
subplot(212);
plot(t,simdata(Nu+1:Nu+Ny,:),t,r,'k')
legend('y1','y2','y3','r')
title('Réponse en boucle fermée')
xlabel('Temps [s]');

figure(3)
subplot(211);
plot(t,exitflag);
title('Exit Flag');
subplot(212);
plot(t,crit);
title('Critère');