clc; clear; close all;
success1 = 0;
success2 = 0;

%% Compute the Unstructured Real Stability Radius for uncontrolled system M
%  and for vibrationally controlled system M_bar
for idx = 1:inf
	% Generation of network (which is stable enough) 
	scalar_net
	while max(real(eig_M))>=-0.1 %&& max(real(eig_M))<=-0.2
		scalar_net
	end
	T = -1/max(real(eig_M))*2*pi;

	%Generation of average system
	test_meerkov_nonscalar_equal

	% Analysis of URSR
	sys1 = ss(M, eye(N), eye(N), zeros(N));
	ursr1 = hinfnorm(sys1)^-1
	
	sys2 = ss(M_bar, eye(N), eye(N), zeros(N));
	ursr2 = hinfnorm(sys2)^-1
	
	if ursr2 > ursr1*2
		success1 = 1;
		break
	end
end

%% Analyse stability 
for idx = 1:inf
	% Generation of perturbation matrix whose norm is between the bounds
	Delta = random(-1,1,N,N);
	Delta = Delta.*M;
	Delta = Delta/norm(Delta); % making the norm unitary
	Delta = Delta * (ursr2*50+ursr1*1)/51; % making the norm between the boundaries
	Delta = round(Delta,1);
	% Check for (enough) instability
	if max(real(eig(M+Delta))) > 0.1
		success2 = 1;
		break
	end
end

% Analysis of stability
eig_M_perturb = eig(M+Delta)
eig_Mbar_perturb = eig(M_bar+Delta)
success1
success2
