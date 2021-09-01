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
% @file Tools/Reconstruction/InertialSensors/TrajectoryReconstruction.scilab
% @author Fabien Jammes
%
% Affiliation(s): INRIA, team BIPOP
%
% Email(s): Fabien.Jammes@inria.fr
% 
% @brief Computes the process noise  matrix for the Kalman filter
% 


function Q = ProcessNoiseMatrix(W,LDOFU,qutilises, Tq, Rq, Te)

T = [find(qutilises == Tq(1)) find(qutilises == Tq(2)) find(qutilises == Tq(3))];
R = [find(qutilises == Rq(1)) find(qutilises == Rq(2)) find(qutilises == Rq(3))];

ST =length(T);
SR =length(R);

c1 = W/20*Te^5; c1 = [ones(1,ST)*c1(1) ones(1,SR)*c1(2) ones(1,LDOFU-(ST+SR))*c1(3)];
c2 = W/8*Te^4;  c2 = [ones(1,ST)*c2(1) ones(1,SR)*c2(2) ones(1,LDOFU-(ST+SR))*c2(3)];
c3 = W/6*Te^3;  c3 = [ones(1,ST)*c3(1) ones(1,SR)*c3(2) ones(1,LDOFU-(ST+SR))*c3(3)];
c4 = W/3*Te^3;  c4 = [ones(1,ST)*c4(1) ones(1,SR)*c4(2) ones(1,LDOFU-(ST+SR))*c4(3)];
c5 = W/2*Te^2;  c5 = [ones(1,ST)*c5(1) ones(1,SR)*c5(2) ones(1,LDOFU-(ST+SR))*c5(3)];
c6 = W*Te;      c6 = [ones(1,ST)*c6(1) ones(1,SR)*c6(2) ones(1,LDOFU-(ST+SR))*c6(3)];


v1=diag(c1);v1=[v1,diag(c2)];v1=[v1,diag(c3)];
v2=diag(c2);v2=[v2,diag(c4)];v2=[v2,diag(c5)];
v3=diag(c3);v3=[v3,diag(c5)];v3=[v3,diag(c6)];

Q = [v1;v2;v3];

end
