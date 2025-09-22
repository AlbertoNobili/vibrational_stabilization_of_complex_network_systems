clc 
% clear 
close all
N = 5; % # of nodes
n = 1; % scalar nodes
x_0 = ones(5,1);

%% Generation of network
A = zeros(5);
M = zeros(5);
M_sub = zeros(3);
for i=1:inf
	% Generation of node systems
	A = - diag(random(1,5,1,5));
	A = round(A,1);
	P1 = rand(3);
	A(1:3,1:3) = P1\A(1:3,1:3)*P1;
	P2 = [1 0 0 0 0;
		  0 0 0 1 0;
		  0 0 1 0 0;
		  0 1 0 0 0;
		  0 0 0 0 1];
	A = P2\A*P2;
	% Generation of connections
	lambda = random(-10,-1,1,3);
	lambda_15 = lambda(1)/lambda(3);
	lambda_32 = lambda(2);
	lambda_51 = lambda(3)/lambda(1);
	Lambda =[0 0 0 0 lambda_15;
         	0 0 0 0 0;
         	0 lambda_32 0 0 0;
         	0 0 0 0 0;
         	lambda_51 0 0 0 0]; 
	Lambda = round(Lambda,1);
	M = A+Lambda;
	% G = digraph(Lambda');
	% figure()
	% plot(G, 'Layout', 'layered')
	M_sub = [M(1,1) M(1,3) M(1,4);
	     	 M(3,1) M(3,3) M(3,4);
		 	 M(4,1) M(4,3) M(4,4)];
	if max(real(eig(M))) > 0.1 && max(real(eig(M_sub))) < -0.1
		break;
	end
end
eig_M = sort(eig(M))
eig_M_sub = sort(eig(M_sub))

%% Generation of vibratioal control
omega_0 = 200;
omega51 = omega_0;
k51 = sqrt(2)*omega51*sqrt(abs(M(5,1)/M(1,5)));

%% Generation of matrices for test
Omega = zeros(5);
Omega(5,1) = omega51;
K = zeros(5);
K(5,1) = k51;


