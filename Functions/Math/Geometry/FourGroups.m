function [C,X,Y,CP]=FourGroups(M)


% nb = factorial(n)/(8*factorial(n/4)^4);
    
    %n=4,  c=3,     t=0.07s
    %n=8,  c=315,   t=0.25s
    %n=12, c=46200, t=27s
    %n=16, c=8e6,   t=5000s
    %n=20, c=1.5e9
    %n=24, c=0.3e12

    if size(M,2)==3
        C = [1 NaN 2 NaN 1 NaN 3];
        X = M(:,1) - M(:,2);
        Y = M(:,1) - M(:,3);
        CP = sum(cross(X,Y).^2);
    else
        
%     tic
    
    % C = zeros(nb,n+1);
        n = size(M,2);
        C = zeros(1,n+3);
        CP = 0;
        AA = nchoosek(1:n, ceil(n/2));
        [nAA,pAA]=size(AA);
        %c=0;


        for i=1:nAA/2
            A = AA(i,:);
            B = setdiff(1:n,A);
            [nB, pB] = size(B);

            aa = nchoosek(A, ceil(pAA/2));
            bb = nchoosek(B, ceil(pB /2));

            naa = size(aa,1);
            nbb = size(bb,1);

            for j=1:ceil(naa/2)

                a1 = aa(j,:);
                a2 = setdiff(A,a1);

                for k=1:ceil(nbb /2)

                    b1 = bb(k,:);
                    b2 = setdiff(B,b1);
                    %c=c+1;
                    tp = cross(mean(M(:,a1),2) - mean(M(:,a2),2), ...
                               mean(M(:,b1),2) - mean(M(:,b2),2));

                    tp = sum(tp.^2);  

                    if tp>CP
                        C = [a1 NaN a2 NaN b1 NaN b2];
                        X = mean(M(:,a1),2) - mean(M(:,a2),2);
                        Y = mean(M(:,b1),2) - mean(M(:,b2),2);
                        CP= tp;
                    end


                    %C(c,:) = [sum(tp.^2) a1 a2 b1 b2];

                end
            end
        end
        
    end%if 3
% toc