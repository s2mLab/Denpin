function [R,Rd, residual, vect_globVersCoRFinal]=Rep_Loc(MM,Rt0_0,M0)

% https://www.researchgate.net/profile/Tony_Monnet/publication/237046936_Improvement_of_the_Input_Data_in_Biomechanics_Kinematic_and_Body_Segment_Inertial_Parameters/links/0046351baa9d0a8eee000000.pdf
% and
% https://www.researchgate.net/publication/15597013_A_procedure_for_determining_rigid_body_transformation_parameters

%R = rotation du local dans le global
%Rd = rotation du local dans la r�f�rence
%vect_globVersCoRFinal = Vecteur de global � CoR2

invPPvect = @(x) [x(3,2);x(1,3);x(2,1)];
PPvect    = @(x) [0,-x(3),x(2);x(3),0,-x(1);-x(2),x(1),0];
unit      = @(x) [x/norm(x)]; %#ok<NBRAK,NASGU>

% % Remplacer d'�ventuel nan par des 0;
% idxNan = isnan(MM);
% MM(idxNan) = 0;

[~,p,q] = size(MM);

if nargin==1
    [C,Xi,Yi,tp] = FourGroups(MM(:,:,1));  %#ok<ASGLU>
    fprintf('4 groups of markers %s \t\n', num2str(C))
    Zi=PPvect(Xi)*Yi;
    Yi=PPvect(Zi)*Xi;
    Rt0_0=[unit(Xi),unit(Yi),unit(Zi)];
    M0 = MM;
elseif nargin == 2
    M0 = MM;
else
end


meanMM = mean(MM,2);
meanM0 = mean(M0,2);

A = MM -   repmat(meanMM, [1 p 1]); % Position du centre au premier instant (static)
A1 = M0 -  repmat(meanM0, [1 p  ]);

% mark = zeros(2, sum([1:p-1])); in=0;
% for i=1:p-1, for j=i+1:p, in=in+1; mark(:,in) = [i ;j]; end; end
% A = MM(:,mark(1,:),:)-MM(:,mark(2,:),:); 

m1=sqrt((1+trace(Rt0_0))/4);
M1=invPPvect(((Rt0_0-Rt0_0')/4)/m1);

T0 = mean(MM(:,:,1),2);
    
%% OPTIM
F=zeros(3,3,q);
for j=1:size(A,2)
    %F=F+A(:,j,t)*A(:,j,1)';
    F=F+multiprod(A(:,j,:), repmat(A1(:,j,1)', [1,1,q]));
end %for j

S=0.5*(F+multitransp(F));

W=(F-multitransp(F));
W=[W(3,2,:);W(1,3,:);W(2,1,:)];

Q=[2*S-multiprod(multitrace(S), repmat(eye(3,3), [1,1,q])),W ;...
    multitransp(W),multitrace(S)];

Y=ones(4,1,q);    
G=0.5*(multiprod(Q,Y)- multiprod(((multiprod(multiprod(multitransp(Y),Q), Y))/4), Y)); 

Z=G;
Yj = Y;    
Zj = Z;    
Gj = G;

%debut des iterations
cond = true(q,1);
Yi=zeros(size(Yj));
Zi=zeros(size(Zj));
Gi=zeros(size(Gj));
ZZi=zeros(1,1,q);
YYi=zeros(1,1,q);
YZi=zeros(1,1,q);
ZiQ=zeros(1,4,q);
YiQ=zeros(1,4,q);
ZiQZi=zeros(1,1,q);
a=zeros(1,1,q);
b=zeros(1,1,q);
c=zeros(1,1,q);
delta=zeros(1,1,q);
mu=zeros(1,1,q);
nu=zeros(1,1,q);
for i=1:200
    Yi(:,:,cond) = Yj(:,:,cond);    
    Zi(:,:,cond) = Zj(:,:,cond);    
    Gi(:,:,cond) = Gj(:,:,cond);  

    ZZi(:,:,cond) = multiprod(multitransp(Zi(:,:,cond)),Zi(:,:,cond));
    YYi(:,:,cond) = multiprod(multitransp(Yi(:,:,cond)),Yi(:,:,cond));
    YZi(:,:,cond) = multiprod(multitransp(Yi(:,:,cond)),Zi(:,:,cond));
    ZiQ(:,:,cond) = multiprod(multitransp(Zi(:,:,cond)),Q(:,:,cond));
    YiQ(:,:,cond) = multiprod(multitransp(Yi(:,:,cond)),Q(:,:,cond));
    ZiQZi(:,:,cond) = multiprod(ZiQ(:,:,cond),Zi(:,:,cond));

    a(:,:,cond)=multiprod(YZi(:,:,cond),ZiQZi(:,:,cond)) - multiprod(ZZi(:,:,cond),multiprod(ZiQ(:,:,cond),Yi(:,:,cond)));
    b(:,:,cond)=multiprod(YYi(:,:,cond),ZiQZi(:,:,cond)) - multiprod(ZZi(:,:,cond),multiprod(YiQ(:,:,cond),Yi(:,:,cond)));
    c(:,:,cond)=multiprod(YYi(:,:,cond), multiprod(ZiQ(:,:,cond), Yi(:,:,cond))) - multiprod(YZi(:,:,cond), multiprod(YiQ(:,:,cond), Yi(:,:,cond)));

    delta(:,:,cond)=(multiprod((multiprod(YYi(:,:,cond),ZZi(:,:,cond))-YZi(:,:,cond).^2),b(:,:,cond).^2)+(multiprod(YYi(:,:,cond),a(:,:,cond)) - multiprod(ZZi(:,:,cond),c(:,:,cond))).^2) ./ (multiprod(YYi(:,:,cond), ZZi(:,:,cond)));
    mu(:,:,cond)=(-b(:,:,cond)-sqrt(delta(:,:,cond)))./(2*a(:,:,cond));

    Yj(:,:,cond)=Yi(:,:,cond)+multiprod(mu(:,:,cond),Zi(:,:,cond));
    Gj(:,:,cond)=multiprod((2/(multiprod(multitransp(Yj(:,:,cond)), Yj(:,:,cond)))),(multiprod(Q(:,:,cond),Yj(:,:,cond))- multiprod(((multiprod(multiprod(multitransp(Yj(:,:,cond)), Q(:,:,cond)), Yj(:,:,cond)))./(multiprod(multitransp(Yj(:,:,cond)), Yj(:,:,cond)))), Yj(:,:,cond))));

    nu(:,:,cond)=(multiprod(multitransp(Gj(:,:,cond)), Gj(:,:,cond)-Gi(:,:,cond))) ./ (multiprod(multitransp(Gi(:,:,cond)), Gi(:,:,cond)));

    Zj(:,:,cond)=Gj(:,:,cond)+multiprod(nu(:,:,cond),Zi(:,:,cond));

    cond = squeeze(multiprod(multitransp(Gj(:,:,cond)), Gj(:,:,cond)) > 1e-15);
    if sum(cond) ==  0
        break
    end
end %for i

X= Yj ./ repmat((sqrt(multiprod(multitransp(Yj),Yj))),[4,1,1]);
md=X(4,1,:);
Md=X(1:3,1,:);

tp1 = multiprod((md.^2-(multiprod(multitransp(Md), Md))),eye(3,3)) + 2*(multiprod(Md, multitransp(Md)))+ multiprod(2*md, PPvectMat(Md));
tp2 = mean(MM,2) + multiprod(tp1, -T0);

Rd = cat(2, tp1, tp2);
Rd(4,4,:) = 1; 

m=multiprod(md, m1) - multiprod(multitransp(Md), M1);
M=multiprod(md, M1) + multiprod(m1,Md) + multiprod(PPvectMat(Md), M1);

R = multiprod((m.^2 - (multiprod(multitransp(M), M))), eye(3,3))+...
    2*multiprod(M, multitransp(M)) + multiprod(2*m , PPvectMat(M));
   


% %% Calcul du vecteur CoR2 dans le global
% globVersIni = repmat(Rt0_0, [1,1,q]); % Matrice de rotation de global vers position initiale
% iniVersFinal = Rd(1:3,1:3,:); % Matrice de rotation de initial vers position finale
% globVersFinal = multiprod(globVersIni, iniVersFinal); % Matrice de rotation de global vers position finale
% coRIni = repmat(trans, [1,1,q]);
% meanIni = repmat(mean(MM(1:3,4,:),3), [1,1,q]);
% vect_CoRMean_ofIni = coRIni - meanIni; % Vecteur entre CoR et centre des marqueurs de la matrice initiale dans le rep�re global
% vect_CoRMean_ofFinal = multiprod(globVersFinal, vect_CoRMean_ofIni); % Vecteur entre CoR et centre des marqueurs de la matrice final dans le rep�re glob
% vect_globVersCoRFinal = meanIni + multiprod(globVersIni, Rd(1:3,4,:)) + vect_CoRMean_ofFinal; % Vecteur de global � CoR2


  R(1:3,4,:)= meanMM; R(4,4,:)=1;
% Rd(1:3,4,:)=  mean(MM,2)-repmat(T0,[1 1 q]); 


residual = nan(q,p);
if nargout>2
    for i=1:p
         tp10 = repmat(Rt0_0'*(M0(:,i)-meanM0),[1,q]);
         tp11 = squeeze(multiprod(multitransp(R(1:3,1:3,:)),(MM(:,i,:)-meanMM)));
         residual(:,i) = squeeze(sqrt(sum((tp10 - tp11).^2)));
    end
end

end

function out = PPvectMat(x)
%     out = [0,-x(3),x(2);...
%            x(3),0,-x(1);...
%            -x(2),x(1),0];

    q = size(x,3);
    out = zeros(3,3,q);
    out(1,2,:) = -x(3,1,:);
    out(1,3,:) = x(2,1,:);
    out(2,1,:) = x(3,1,:);
    out(2,3,:) = -x(1,1,:);
    out(3,1,:) = -x(2,1,:);
    out(3,2,:) = x(1,1,:);
    

end


