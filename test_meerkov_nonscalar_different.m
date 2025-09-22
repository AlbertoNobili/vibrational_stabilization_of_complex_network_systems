%% Test for stability
% This test allows to compute the average matrix in the case of node
% systems of DIFFERENT dimension, allowing that the vibration matrix has
% DIFFERENT amplitude inside each block. We  assume that inside
% vector n=[n_1, ..., n_N] there are the dimensions of every node system, 
% and that K{i,j} is the matrix of gains between blocks i and j .

tic

% Creation of parameters for "state transition" matrix F(t)
Cos = cell(N);
n_mat = zeros(N);
W = Omega;

for i = 2:N
    for j = 1:i-1
        n_mat(i,j) = 1 + 2*sum(n_mat(1:i-1,j));
		s.ampl = zeros(n(i),n(j));
		s.freq = 0;
		if W(i,j) ~= 0
			s.ampl = -K{i,j}/W(i,j);
			s.freq = W(i,j);
		end
		Cos{i,j} = s;
        for l = 1:j-1
            n_jl = n_mat(j,l);
            for m = 1:n_jl
				s1.freq = W(i,j) - Cos{j,l}(m).freq;
				s1.ampl = -1/2 / (W(i,j)-Cos{j,l}(m).freq) * K{i,j}*Cos{j,l}(m).ampl;
				s2.freq = W(i,j) + Cos{j,l}(m).freq;
				s2.ampl = -1/2 / (W(i,j)+Cos{j,l}(m).freq) * K{i,j}*Cos{j,l}(m).ampl;
				if max(abs(s1.ampl),[],'all') ~= 0
					Cos{i,l} = [Cos{i,l}; s1];
				end
				if max(abs(s2.ampl),[],'all') ~= 0
					Cos{i,l} = [Cos{i,l}; s2];
				end
            end
        end
    end
end

% Creation of "state transition" matrix F(t)
syms t
F = sym(zeros(sum(n)));
for i=2:N
	start_i = sum(n(1:i-1)) + 1;
    end_i = start_i + n(i) - 1;
    for j=1:i-1
        start_j = sum(n(1:j-1)) + 1;
        end_j = start_j + n(j) - 1;
		F(start_i:end_i, start_j:end_j) = zeros(n(i),n(j));
		for idx = 1:size(Cos{i,j},1)
			F(start_i:end_i, start_j:end_j) = F(start_i:end_i, start_j:end_j) + ...
				Cos{i,j}(idx).ampl*cos(Cos{i,j}(idx).freq*t);
		end
    end
end

% Creation of averaged matrix B_bar
B_bar = zeros(sum(n));
%B_bar = sym(zeros(sum(n)));
for i=1:N
	start_i = sum(n(1:i-1)) + 1;
	for j=1:N
		start_j = sum(n(1:j-1)) + 1;
		for l=1:n(1)
			for m=1:n(j)
				temp = 0;
				for k=1:n(j)
					for h=1:n(i)
						for idx=1:size(Cos{i,j},1)
							app = Cos{i,j}(idx).ampl;
							app2 = app(l,k) * app(h,m);
							app2 = 1/2 * app2;
							temp = temp + app2*M(start_j+k-1, start_i+h-1);
						end
					end
				end
				B_bar(start_i+l-1, start_j+m-1) = - temp;
			end
		end
	end
end

M_bar = M + B_bar
eig_M_bar = sort(eig(M_bar))
duration = toc;
% fprintf("Duration of fast stability test: %d sec\n", duration);
