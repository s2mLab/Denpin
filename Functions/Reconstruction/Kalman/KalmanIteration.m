% Copyright (C) INRIA 1999-2008
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License version 2 as published
% by the Free Software Foundation.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
%%
% @file Kernel/Kalman-Filter/KalmanIteration.scilab
% @author Fabien Jammes
%
% Affiliation(s): INRIA, team BIPOP
%
% Email(s): Fabien.Jammes@inria.fr
% 
% @brief Kalman Filtering Function
% 

% Description:
% 
% Modifications:
% 

%%
% Compute On iteration o the Kalman filter
%  @param A state evolution matrix
%  @param z measurement
%  @param zest  measurement estimation 
%  @param Pp previous state estimate covariance matrix
%  @param xp previous state estimate
%  @param Q process noise covariance matrix
%  @param R measurement noise covariance matrix
%  @param H Measurement function matrix (Linearization of this function for the non-linear case)
%
%
%
%  @return x new state estimate
%  @return P new state estimates' covariance matrix
%  @return res residual
%  @return K Kalman gain
%  @return Pkm projected covariance matrix 

function [x,P,res,K,Pkm] = KalmanIteration(A,z,zest,Pp,xp,Q,R,H,W0)

%[x1,p1,x,p]=kalm(y,x0,p0,f,g,h,q,r)% appel de la fonction scilab pb avec g et q
%   k=p0*h'*(h*p0*h'+r)**(-1);
%   p=(eye(p0)-k*h)*p0;
%   p1=f*p*f'+g*q*g';
%   x=x0+k*(y-h*x0);
%   x1=f*x;



	% Pr�diction
	xkm = A*xp;
    Pkm =A*Pp*A'+Q; 								%A priori covariance matrix and state estimate
	
    % Mise � jour
    idxNan = isnan(z);
	res(~idxNan) = z(~idxNan)-zest(~idxNan);
	res(idxNan) = zest(idxNan);
	res = W0*res';
	K = Pkm*H'/(H*Pkm*H'+R);						%Kalman gain	
% 	K = Pkm*H'*inv((H*Pkm*H'+R));						%Kalman gain	
	x = xkm+K*(res);								%New state estimate and state estimates' covariance matrix
	P = (eye(size(Pp))-K*H)*Pkm*(eye(size(Pp))-K*H)'+K*R*K';	%Joseph form which is known to have a better numerical behavior than the previous one.
	
	
	

end
