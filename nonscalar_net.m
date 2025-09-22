%clc; clear; close all
N = 3; % # of nodes
n = [1,3,1]; % dimension of each nodes
x_0 = ones(sum(n),1);
omega = 50;
model = 'simulation_nonscalar';

%% Generation of node systems
lambda1 = random(-5,5,1,3);
A = - diag(random(2,5,1,5));
A(2,4) = lambda1(1);
A(3,2) = lambda1(2);
A(4,3) = lambda1(3);
A = round(A,1);
eig_A = sort(eig(A))

%% Generation of connections
lambda2 = random(1,10,1,6);
Lambda(2,1) = lambda2(1);
Lambda(2,5) = lambda2(2);
Lambda(3,1) = lambda2(3);
Lambda(4,5) = lambda2(4);
Lambda(5,3) = lambda2(5);
Lambda(5,4) = lambda2(6);
if sign(Lambda(4,5)*Lambda(5,4))<0
	Lambda(4,5) = Lambda(4,5)*sign(Lambda(4,5))*sign(Lambda(5,4));
end
M = A+Lambda;
M = round(M,1);
eig_M = sort(eig(M))
G = digraph((M-diag(diag(A)))');
figure()
plot(G, 'Layout', 'layered')

%% Generation of vibratioal control
%omega = omega_0;
mu = sqrt(abs(2/(M(4,5)*M(5,4))))*omega;

%% Generation of matrices for test
Omega = zeros(3);
Omega(3,2) = omega;
K = cell(3);
K{3,2} = mu*M(5,2:4);

%% Test for stability of averaged system
test_meerkov_nonscalar_different
F_0 = subs(F,0);
inv_F0 = inv(F_0+eye(sum(n)));
y_0 = double(inv_F0*x_0);
matlabFunctionBlock([model '/F(t)'], F); 
