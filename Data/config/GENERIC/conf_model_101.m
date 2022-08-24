% Clone of the model 1 with the thorax as root
%1=thorax; 2=scapula; 3=upperarm;

conf.segments=3;%nombre de segments
conf.CoR=2;%nombre de CoR 

%Thorax 'T8','C7','IJ','PX'
s=1;
conf.S(s).n=4;
conf.S(s).nT=4; 
conf.S(s).parent = 0;
conf.S(s).name='Thorax';
conf.S(s).U=[4 -1]; 
conf.S(s).V=[3 -4]; 
conf.S(s).keep=2;
conf.S(s).xyz='y';
conf.S(s).O=3;
conf.S(s).dof=[1 2 3 4 5 6]; 
conf.S(s).seq='zyx';

%Scapula 'ScapClus1','ScapClus2','ScapClus3','ScapClus4','AA','TS','AI','ACJ1'
s=2;
conf.S(s).n=8;
conf.S(s).nT=5; 
conf.S(s).parent = 1;
conf.S(s).name='Scapula';
conf.S(s).U=[-7 5]; 
conf.S(s).V=[-6 5]; 
conf.S(s).keep=2;
conf.S(s).xyz='z';
conf.S(s).O=8;
conf.S(s).dof=[1 2 3 4 5 6]; 
conf.S(s).seq='zyx';

%Upperarm 'Hu1','Hu2','Hu3','Hu4','Hu5','LE','ME','PFA','DFA','RS','US','brace1','brace2','brace3','brace4','brace5','brace6'
s=3;    
conf.S(s).Joint='cor';
conf.S(s).JointDeterminationType = 'anatomicalRab';
conf.S(s).JointAnatomicalMarker=[6 7];
conf.S(s).n=17; 
conf.S(s).nT=5; 
conf.S(s).parent = 2;
conf.S(s).name='Upperarm';
conf.S(s).U=[18 18 -6 -7];
conf.S(s).V=[6 -7];
conf.S(s).keep=1;
conf.S(s).xyz='z';
conf.S(s).O=18;
conf.S(s).dof=[7 8 9 10 11 12];
conf.S(s).seq='zyz';
