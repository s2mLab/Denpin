function [A,W,Q,R,xp, Pp] = InitializeKalman(qutilises,Te, Tq, Rq, w0)

%essayer avec simplement position et vitesse.

	%Initialisation pour Filtre de Kalman
	A = EvolutionMatrix(sum(qutilises),2,Te);
	W = [1 1 1]; % translation, rotation, gesticulation
	Q = ProcessNoiseMatrix(W,sum(qutilises),qutilises, Tq, Rq, Te);
	R = MeasurementNoiseMatrix(1e-9, w0);
	
	xp = zeros(3*sum(qutilises),1);
	Pp = eye(sum(qutilises)*3,sum(qutilises)*3)*1e-5;  
	
end