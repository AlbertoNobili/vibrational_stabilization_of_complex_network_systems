clc; clear; close all
N = 5; % # of nodes
n = 1; % scalar nodes
x_0 = ones(5,1);
omega_0 = 200;
epsilon = 0.25;
model = 'simulation_scalar';

%% Generation of network
% Generation of node systems
A = - diag(random(0.1,10,1,N));
A = round(A,1);
eig_A = sort(eig(A))
% Generation of connections
lambda = random(1,10,1,7);
random_sign = sign(rand(1,7));
lambda = lambda .* random_sign;
lambda_14 = lambda(1);
lambda_15 = lambda(2);
lambda_31 = lambda(3);
lambda_32 = lambda(4);
lambda_34 = lambda(5);
lambda_43 = lambda(6);
lambda_51 = lambda(7);
if sign(lambda_15*lambda_51)<0
	lambda_51 = lambda_51*sign(lambda_51)*sign(lambda_15);
end
if sign(lambda_34*lambda_43)<0
	lambda_43 = lambda_43*sign(lambda_43)*sign(lambda_34);
end
Lambda =[0 0 0 lambda_14 lambda_15;
         0 0 0 0 0;
         lambda_31 lambda_32 0 lambda_34 0;
         0 0 lambda_43 0 0;
         lambda_51 0 0 0 0];
Lambda = round(Lambda,1);
M = A+Lambda
eig_M = sort(eig(M))
% G = digraph(Lambda');
% figure()
% plot(G, 'Layout', 'layered')

%% Generation of stable network
k = 0.1;
Lambda2 = Lambda*k;
M_stable = A+Lambda2;
eig_M_stable = sort(eig(M_stable))

%% Generation of first vibratioal control
omega43 = omega_0;
k43 = sqrt(2)*omega43*sqrt(abs(M(4,3)/M(3,4)));
omega51 = sqrt(2) * omega_0;
k51 = sqrt(2)*omega51*sqrt(abs(M(5,1)/M(1,5)));

% Generation of matrices for test
Omega = zeros(5);
Omega(4,3) = omega43;
Omega(5,1) = omega51;
K = zeros(5);
K(4,3) = k43;
K(5,1) = k51;

% %% Generation of second vibratioal control
% omega43_2 = omega_0;
% k43_2 = sqrt(2)*omega43_2*sqrt(abs((M(4,3)-epsilon)/M(3,4)));
% omega51_2 = sqrt(2) * omega_0;
% k51_2 = sqrt(2)*omega51_2*sqrt(abs((M(5,1)-epsilon)/M(1,5)));
% 
% % Generation of matrices for test
% Omega = zeros(5);
% Omega(4,3) = omega43_2;
% Omega(5,1) = omega51_2;
% K = zeros(5);
% K(4,3) = k43_2;
% K(5,1) = k51_2;

%% Test for stability of averaged system
test_meerkov_nonscalar_equal
F_0 = subs(F,0);
inv_F0 = inv(F_0+eye(N));
y_0 = double(inv_F0*x_0);
matlabFunctionBlock([model '/F(t)'], F); 

