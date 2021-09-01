function [R] = Rep_Loc2(M,a,b)

%% Auteur :                 BEGON Mickael
%% Organisation :           Laboratoire de M�canique des Solides, Poitiers
%% Cr�ation :               

    
    
    switch nargin,
        case 1,
            M = M(1:3,:,:);
            for k=1:size(M,3);
                Or = M(:,1,k);
                X  = M(:,2,k)-Or;
                Y  = M(:,3,k)-Or;
                Z  = PPV(X)*Y; Z = Z/norm(Z);
                Y  = PPV(Z)*X; Y = Y/norm(Y);
                X = X/norm(X);
                R(:,:,k) = [X Y Z Or ; 0 0 0 1];
            end%for k
            
        case 3,
            for k=1:size(M,3);
                Or = M(1:3,1,k);
                A  = M(1:3,2,k);
                B  = M(1:3,3,k);
                
                C = PPV(A)*B;
                if a==1, B = PPV(C)*A; 
                else,    A = PPV(B)*C;
                end
                
                A = A/norm(A);
                
                B = B/norm(B);
                
                C = C/norm(C);
                switch lower(b),
                    case 'x', R(:,:,k) = [A B C Or ; 0 0 0 1];        
                    case 'y', R(:,:,k) = [C A B Or ; 0 0 0 1];    
                    case 'z', R(:,:,k) = [B C A Or ; 0 0 0 1]; 
                end%switch b
            end%for k
    end%switch nargin