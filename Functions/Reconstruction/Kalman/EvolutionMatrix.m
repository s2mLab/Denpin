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
% @author Florence Billet
%
% Affiliation(s): INRIA, team BIPOP
%
% Email(s): Fabien.Jammes@inria.fr
% 
% @brief Computes the Evolution matrix for the Kalman filter
% 


function A = EvolutionMatrix(m,n,Te)
    %m nombre de degré de liberté
    %n ordre du développent de Taylor

    n = n+1;
    A = eye(m*n,m*n);
    c = 1;
    for i = 2:n 

      j=i-1; 
      jm = j*m;
      c = c/j;
      ni = n-i+1;
      mni = m*ni;

      A(1:end-jm,jm+1:end) = A(1:end-jm,jm+1:end)+ eye(mni,mni)*c*Te^j;

    end 

end
