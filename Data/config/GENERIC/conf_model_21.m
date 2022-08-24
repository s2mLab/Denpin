%%FICHIER CONFIGURATION: Modele 1 - S2M Jackon, 2012
% 1a=REFERENCE(SC:3dof; AC:3dof; GH:6dof)
% 1b=comme 1a sauf GH:3dof
% 1c=SC(2 dof), AC(2 dof),GH(3 dof)
% 1d=Modele classique (GH:6dof en rotation)

%1=scapula; 2=upperarm;

conf.segments=2;%nombre de segments
conf.CoR=1;%nombre de CoR 

%Scapula 'ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4','AA','TS','AI','ACJ1','ScapClus1','ScapClus2','ScapClus3','ScapClus4'
s=1;
conf.S(s).n=12;
conf.S(s).nT=4; 
conf.S(s).parent = 0;
conf.S(s).name='Scapula';
conf.S(s).U=[-7 5]; 
conf.S(s).V=[-6 5]; 
conf.S(s).keep=2;
conf.S(s).xyz='z';
conf.S(s).O=8;
conf.S(s).dof=[1 2 3 4 5 6]; 
conf.S(s).seq='zyx';

%Upperarm 'HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4','LE','ME','Hu1','Hu2','Hu3','Hu4','Hu5','PFA','DFA','RS','US', 'brace1','brace2','brace3','brace4','brace5','brace6'
s=2;    
conf.S(s).Joint='cor';
conf.S(s).JointDeterminationType = 'functional';
conf.S(s).n=21; 
conf.S(s).nT=4; 
conf.S(s).parent = 1;
conf.S(s).name='Upperarm';
conf.S(s).U=[22 22 -5 -6];
conf.S(s).V=[5 -6];
conf.S(s).keep=1;
conf.S(s).xyz='z';
conf.S(s).O=22;
conf.S(s).dof=[7 8 9 10 11 12];
conf.S(s).delta = [5 5 5 0 0 0]/100; 
conf.S(s).seq='zyz';
