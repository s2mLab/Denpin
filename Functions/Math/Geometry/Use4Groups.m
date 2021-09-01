function R = Use4Groups(M,c)

PPV = @(x) [0,-x(3),x(2);x(3),0,-x(1);-x(2),x(1),0];
unit = @(x) [x/norm(x)];


    a = find(isnan(c));
    a1=c(      1 : a(1)-1);
    a2=c( a(1)+1 : a(2)-1);
    b1=c( a(2)+1 : a(3)-1);

%     if a(3)+1==length(c), b2=c(a(3)+1); else   
        b2=c( a(3)+1 : end); 
%     end
    X = mean(M(:,a1),2) - mean(M(:,a2),2);
    Y = mean(M(:,b1),2) - mean(M(:,b2),2);
    
    Z=PPV(X)*Y; Y=PPV(Z)*X; 
    R = [unit(X) unit(Y) unit(Z)];     





