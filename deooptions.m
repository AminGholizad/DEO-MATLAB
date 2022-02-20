function options = deooptions()
%% problem params
options.max_iter = 200; %maximum iterations
options.lower_bound = [0,0,0,0]; %lower bound of vars
options.upper_bound = [pi/2,pi/2,pi/2,pi/2]; %upper bound of vars
options.pop_size=200; % population size
options.problem=@cost_fcn; % objective function and constraint function
%% deo coefficients
options.F = 0.8; % differential weight
options.CR = 0.9; % crossover probability
%% display
options.display = true;
