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
% @file Tools/Reconstruction/OpticalSensors/KalmanReconstruction.scilab
% @author Fabien Jammes
%
% Affiliation(s): INRIA, team BIPOP
%
% Email(s): Fabien.Jammes@inria.fr
% 
% @brief Compute the state estimate for the Arm Model
% 

% Description:
% 
% Modifications:
% 

%%
% Compute the articular position qrec which correspond to the observed tags Tobs  
%  @param A state evolution matrix
%  @param z measurement
%  @param Pp previous state estimate covariance matrix
%  @param xp previous state estimate
%  @param Q process noise covariance matrix
%  @param R measurement noise covariance matrix
%  @param DOFUtil Degree of liberty which are used
%  @param ISUtil used measurements (Inertial Sensor Util)
%  @param qrec state (the position componant) given by an external system as OptotraK
%
%
%  @return x new state estimate
%  @return P new state estimates' covariance matrix
%
function [xp, q, Pp,er,K,Pkm] = KalmanReconstruction(r,A,z,Pp,xp,Q,R,Tutilises,Tutilises3,TutilisesJ,qrec,W0)


% global NTAG qref
% fonctions appelees Tags, TagsJacobian KalmanIteration

% 	Tutilises1 = false(NTAG,1);
% 	Tutilises1(Tutilises) = true;
% 	Tutilises3=[Tutilises1;Tutilises1;Tutilises1];

	Rutilises = R(Tutilises3,Tutilises3);

	xkm = A*xp; % État projeté
	
	q = qrec; 						%initialiser à la position de reference surtout si modele > 1; 	
	q(r.qutilises,1)= xkm(1:end/3,1); 	%q(Rq) = qrec(Rq); 

    zest = forwardKin(r,Tutilises,q); % Mesures projetées
    J = W0(Tutilises3, Tutilises3)*JacobianQ(r,q,TutilisesJ, [], z); % Jacobienne des mesures projetées
	H = [J zeros(size(J)) zeros(size(J))]; % Jaco + vitesse + Acc
	z = z(:,Tutilises)';
	
	[xp,Pp,er,K,Pkm] = KalmanIteration(A,z(:),zest(:),Pp,xp,Q,Rutilises,H,W0(Tutilises3, Tutilises3));
	

end

