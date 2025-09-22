%% To create data for latex plot

%% Scalar simulation
save('scalar.mat');

state1 = out.ctrl.Data;
state1_t = [out.tout state1];
save('scalar_ctrl.dat', 'state1_t', '-ascii');

state2 = out.non_ctrl.Data;
state2_t = [out.tout state2];
save('scalar_no_ctrl.dat', 'state2_t', '-ascii');

state3 = out.stable.Data;
state3_t = [out.tout state3];
save('scalar_stable.dat', 'state3_t', '-ascii');

state4 = out.ctrl2.Data;
state4_t = [out.tout state4];
save('scalar_ctrl2.dat', 'state4_t', '-ascii');

%% Scalar exception
save('exception.mat');

state1 = out.ctrl.Data;
state1_t = [out.tout state1];
save('exception_ctrl.dat', 'state1_t', '-ascii');

state2 = out.non_ctrl.Data;
state2_t = [out.tout state2];
save('exception_no_ctrl.dat', 'state2_t', '-ascii');

%% Nonscalar simulation
save('nonscalar.mat', 'M','omega');

state1 = out.ctrl.Data;
state1_t = [out.tout state1];
save('nonscalar_ctrl1_200.dat', 'state1_t', '-ascii');

state1 = out.ctrl2.Data;
state1_t = [out.tout state1];
save('nonscalar_ctrl2_200.dat', 'state1_t', '-ascii');

state2 = out.non_ctrl.Data;
state2_t = [out.tout state2];
save('nonscalar_no_ctrl.dat', 'state2_t', '-ascii');

%% Robustness example
save('robustness.mat');

state1 = out.ctrl.Data;
state1_t = [out.tout state1];
save('robustness_ctrl.dat', 'state1_t', '-ascii')

state2 = out.non_ctrl.Data;
state2_t = [out.tout state2];
save('robustness_no_ctrl.dat', 'state2_t', '-ascii')
