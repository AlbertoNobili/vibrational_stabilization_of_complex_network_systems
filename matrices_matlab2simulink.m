model = 'simulation_nonscalar';

fprintf('Starting creating Simulink block for matrix F(t)...\n')
tic; 
matlabFunctionBlock([model '/F(t)'], F); 
duration = toc;
fprintf('... duration = %d s\n\n', duration)