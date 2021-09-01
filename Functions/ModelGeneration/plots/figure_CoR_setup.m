function figure_CoR_setup(conf, r,s, M,M1,M2, RT1, RT2)



figure('name', sprintf('%s - %s : CoR dans l''essai', conf.S(r).name, conf.S(s).name));
hold on
im=1; 

CoR = conf.S(s).CoR;
AoR = conf.S(s).AoR;

for seg=1:conf.segments
    % variables temporaires
    a = conf.num(seg,1);%first marker
    b = conf.num(seg,2);%last marker
    c = conf.num(seg,3); % last technical marker
    
    tp1= M(:,a:c,im);
    tp2= M(:,c+1:b,im);
    
    plot3( tp1(1,:), tp1(2,:), tp1(3,:), '.','color',conf.colo(seg));   
    plot3( tp2(1,:), tp2(2,:), tp2(3,:), 'o','color',conf.colo(seg));   
end


plot3(M1(1,:,im),M1(2,:,im),M1(3,:,im), '^', 'color', conf.colo(r));
plot3(M2(1,:,im),M2(2,:,im),M2(3,:,im), 'v', 'color', conf.colo(s));

text (M1(1,:,im),M1(2,:,im),M1(3,:,im), int2str([1:conf.S(r).nT]'));
text (M2(1,:,im),M2(2,:,im),M2(3,:,im), int2str([1:conf.S(s).nT]')); 

if ~isempty(RT2)
    t1 = RT1(:,:,im)*[CoR(4:6);1];   plot3(t1(1),t1(2),t1(3), 'o-','color', conf.colo(s));
    t2 = RT2(:,:,im)*[CoR(1:3);1];   plot3(t2(1),t2(2),t2(3), 's-','color', conf.colo(s));
    t3= 0.5*(t1+t2);                 plot3(t3(1),t3(2),t3(3), 'k*'); 
    plotRef(RT1,1);
    plotRef(RT2,1);
else
    t3 = RT1(:,:,im)*[CoR;1];plot3(t3(1),t3(2),t3(3), 'k*'); 
    plotRef(RT1,1);
end



if strcmp(conf.S(s).Joint,'aor')
    t4_ = 0.05*unit(RT1(:,:,im)*[AoR(4:6);0]); t4= [t1-t4_,t1+t4_]; 
    t5_ = 0.05*unit(RT2(:,:,im)*[AoR(1:3);0]); t5= [t2-t5_,t2+t5_]; 
    t6 = 0.5*(t4+t5);                                           

    plot3(t4(1,:),t4(2,:),t4(3,:),'r-');
    plot3(t5(1,:),t5(2,:),t5(3,:),'g-');
    plot3(t6(1,:),t6(2,:),t6(3,:),'b-');

end%if JointType


axis equal
