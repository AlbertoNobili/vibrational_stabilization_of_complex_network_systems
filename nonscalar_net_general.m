clc; clear; close all

%% Network
N = 4; % # of nodes
n = [1,1,1,1]; % dimension of each nodes
M = sym('M',sum(n));

%% Vibrational control
Omega = sym('Omega',N);
Mu = sym('Mu', N);
K = cell(N);
for i=1:N
	for j=i:N
		Omega(i,j) = 0;
		Mu(i,j) = 0;
	end
end
for i=1:N
	for j=1:N
		start_i = sum(n(1:i-1)) + 1;
        end_i = start_i + n(i) - 1;
        start_j = sum(n(1:j-1)) + 1;
        end_j = start_j + n(j) - 1;
		if j ~= (i-1) 
			Mu(i,j) = 0;
		end
		K{i,j} = M(start_i:end_i,start_j:end_j) * Mu(i,j);
	end
end
