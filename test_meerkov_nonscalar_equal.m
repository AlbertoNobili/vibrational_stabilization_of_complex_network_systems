%% Test for stability
% This test allows to compute the average matrix in the case of node
% systems of EQUAL dimension, supposing that the vibration
% matrix has the SAME amplitude inside each block

tic

% Creation of parameters for "state transition" matrix F(t)
Cos = cell(N);
n_vect = zeros(N,1);
n_vect(1) = 0;
n_vect(2) = 1;
n_mat = zeros(N);
n_mat(2,1) = 1;
W = Omega;
if W(2,1) == 0
	Cos{2,1} = [0, 0];
else
	Cos{2,1} = [-K(2,1)/W(2,1), W(2,1)];
end
for i = 3:N
    n_vect(i) = (i-1) + 2*sum(n_vect(1:i-1));
    for j = 1:i-1
        n_mat(i,j) = 1 + 2*sum(n_mat(1:i-1,j));
		if W(i,j) == 0
			Cos{i,j} = [0, 0];
		else
			Cos{i,j} = [-K(i,j)/W(i,j), W(i,j)];
		end
        for l = 1:j-1
            [j,l];
            n_jl = n_mat(j,l);
            for m = 1:n_jl
                [i,l,m];
				if W(i,j) == 0
					Cos{i,l} = [ Cos{i,l};
									 0, 0;
									 0, 0];
				else
					Cos{i,l} = [ Cos{i,l};
                    -1/2*n / (W(i,j)-Cos{j,l}(m,2)) * K(i,j)*Cos{j,l}(m,1), ...
                        W(i,j)-Cos{j,l}(m,2);
                    -1/2*n / (W ...
					(i,j)+Cos{j,l}(m,2)) * K(i,j)*Cos{j,l}(m,1), ...
                        W(i,j)+Cos{j,l}(m,2)
					];
				end
            end
        end
    end
end

% Creation of "state transition" matrix F(t)
syms t
F = sym(zeros(n*N));
for i=2:N
    for j=1:i-1
        start_i = (i-1)*n+1;
        end_i = i*n;
        start_j = (j-1)*n+1;
        end_j = j*n;
        F(start_i:end_i, start_j:end_j) = ones(n) * sum(Cos{i,j}(:,1)'*cos(Cos{i,j}(:,2)*t));
    end
end

% Creation of M_prime matrix
M_prime = zeros(N*n);
for i=2:N
	start_i = (i-1)*n+1;
    end_i = i*n;
    for j=1:i-1
        start_j = (j-1)*n+1;
        end_j = j*n;
        M_prime(start_i:end_i, start_j:end_j) = ones(n) * ...
            sum( M(start_j:end_j, start_i:end_i) , 'all');
    end
end

% creation of mean square matrix C
C = zeros(N*n);
for i=2:N
	start_i = (i-1)*n+1;
    end_i = i*n;
    for j=1:i-1
        start_j = (j-1)*n+1;
        end_j = j*n;
        ampl = Cos{i,j}(:,1);
        C(start_i:end_i, start_j:end_j) = ones(n) * ...
            1/2*(sum(ampl.^2));
    end
end

V_bar = -(M_prime .* C);
M_bar = M + V_bar;
eig_M_bar = sort(eig(M_bar))
duration = toc;
%fprintf("Duration of fast stability test: %d sec\n", duration);
