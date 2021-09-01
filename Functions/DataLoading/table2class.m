function [New, instant] = table2class(M,option1,option2)
%Change the data configuration from 2D matrix  to  3D matrix
       % M  : dim 1=time, dim 2=M1(XYZ) M2(XYZ)...
       % New: dim 1=XYZ,  dim 2=Markes, dim3=time
       
       % option can remove sample with 0

%LMS �quipe Analyse de la Performance Sportive
%Fonction cr�e par Mickael BEGON le 24 f�vrier 2003
%derni�re modification : 2 avril 2003


[n,p] = size(M);
if p/3==round(p/3); a=1; else a=2; end

New = nan(3,round((p-a+1)/3),n);

switch nargin
    case 1, 
        for i=1:n; col=0;
            for j=a:3:size(M,2),col=col+1; New(:,col,i) = M(i,j:j+2); end%for j
        end%for i
        instant = 1:n;
        
    case 2,
        lign=0; instant=[];
        if option1~=0, 
             COL = option1; 
        else COL = a:p; 
        end
        
        
        
        
        for i=1:n;
            if isempty(find( M(i,COL)==0,1)) && isempty(find(isnan(M(i,COL)),1));
                lign=lign+1;col=0;  
                for j=a:3:size(M,2),
                    col=col+1; 
                    New(:,col,lign) = M(i,j:j+2); 
                end%for j
                instant = [instant;i];    %#ok<AGROW>
            end%if
        end%for i
        
        New = New(:,:,1:lign);
        
   case 3,
        lign=0; instant=[];
        COL=a:3:3*option2;
        for i=1:n;
            if isempty(find( M(i,COL)==0,1)) && isempty(find(isnan(M(i,COL)),1));
                lign=lign+1;col=0;  
                for j=a:3:size(M,2),
                    col=col+1; 
                    New(:,col,lign) = M(i,j:j+2); 
                end%for j
                instant = [instant;i];    %#ok<AGROW>
            end%if
        end%for i
        
        New = New(:,:,1:lign);

end%switch
