clc; clear ; close all
N = 5; % # of nodes
n = 1; % scalar nodes
x_0 = ones(5,1);
omega_0 = 50;

%% Generation of network
A = zeros(5);
M = zeros(5);
for i=1:inf
	% Generation of node systems
	A = - diag(random(1,5,1,5));
	A = round(A,1);
	% Generation of connections
	lambda = random(-10,-0.1,1,6);
	lambda_14 = lambda(1);
	lambda_15 = lambda(2)/lambda(6);
	lambda_31 = lambda(3);
	lambda_32 = lambda(4);
	lambda_43 = lambda(5);
	lambda_51 = lambda(6)/lambda(2);
	Lambda =[0 0 0 lambda_14 lambda_15;
         	0 0 0 0 0;
         	lambda_31 lambda_32 0 0 0;
         	0 0 lambda_43 0 0;
         	lambda_51 0 0 0 0];
	Lambda = round(Lambda,1);
	M = A+Lambda;
	% G = digraph(Lambda');
	% figure()
	% plot(G, 'Layout', 'layered')
	M_sub = [M(1,1) M(1,3) M(1,4);
	     	 M(3,1) M(3,3) M(3,4);
		 	 M(4,1) M(4,3) M(4,4)];
	if max(real(eig(M))) > 0.05 && max(real(eig(M_sub))) < -0.05
		break;
	end
end
eig_M = sort(eig(M))
eig_M_sub = sort(eig(M_sub))

%% Generation of vibratioal control
omega43 = omega_0;
k43 = 0;
omega51 = omega_0;
k51 = sqrt(2)*omega51*sqrt(abs(M(5,1)/M(1,5)));

% Generation of matrices for test
Omega = zeros(5);
Omega(4,3) = omega43;
Omega(5,1) = omega51;
K = zeros(5);
K(4,3) = k43;
K(5,1) = k51;
