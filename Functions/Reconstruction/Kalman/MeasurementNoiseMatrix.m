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
% @file
% @author Florence Billet
%
% Affiliation(s): INRIA, team BIPOP
%
% Email(s): Fabien.Jammes@inria.fr
% 
% @brief Computes the measurement noise  matrix for the Kalman filter
% 


function R = MeasurementNoiseMatrix(MN, w0)

	w = ones(size(w0))./w0; 
	R = diag(w);
	R = R/norm(R)*MN;

end


