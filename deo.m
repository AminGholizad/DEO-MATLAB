function [gBest, Population] = deo(options)

%% initialize parameters
if nargin==0
    options=deooptions();
end
%% initialize agents
Population(1,options.pop_size) = Agent();
for i =1:options.pop_size
    Population(i)=Agent(options.lower_bound,options.upper_bound,options.problem,options.F,options.CR);
end
gBest = Population.best();
%% Loop
for it=1:options.max_iter
    for i =1:options.pop_size % update agents
        Population(i)=Population(i).mutation(Population);
    end
    B = Population.best();
    if B.dominates(gBest) %update global best
        gBest = B;
    end
    if options.display
        M = mean(vertcat(Population.objective));
        C = mean(vertcat(Population.infeasibility));
        if mod(it,10)==1
            fprintf("\t\t\t\tgBest\t\t\t\t\t\tMean\n")
            fprintf("Generation\t\tf(x)\t\tc(x)\t\t\tf(x)\t\t\tc(x)\n")
        end
        fprintf("%d\t\t\t%0.06f\t\t%0.06f\t\t%0.06f\t\t%0.06f\n",it,gBest.objective,gBest.infeasibility,M,C)
    end
end
