clc; clear; close all
N = 3; % # of nodes
n = 1; % scalar nodes
x_0 = ones(N,1);
omega_0 = 50;

%% Generation of network
% Generation of node systems
A = diag([-1,-3,-2]);
eig_A = sort(eig(A));
% Generation of connections
lambda_32 = -4;
lambda_21 = 4;
lambda_13 = 7;
Lambda =[0 0 lambda_13;
         lambda_21 0 0;
         0 lambda_32 0];
M = A+Lambda;
eig_M = sort(eig(M))
% G = digraph(Lambda');
% figure()
% plot(G, 'Layout', 'layered')

%% Generation of v
% Vibratioal control
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

%% Test for stability of averaged system
test_meerkov_nonscalar_equal


