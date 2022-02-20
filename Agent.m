classdef Agent
    %Candidate solution
    properties
        x
        l
        u
        objective
        infeasibility
        fcn
        F
        CR
    end
    
    methods
        function obj = Agent(lower,upper,problem_fcn,F,CR)
            if nargin>0
                obj.x = unifrnd(lower,upper);
                obj.l = lower;
                obj.u = upper;
                obj.fcn = problem_fcn;
                [obj.objective, obj.infeasibility] = obj.fcn(obj.x);
                obj.F = F;
                obj.CR = CR;
            end
        end
        function tf = ne(objs,other)
            tf = any(vertcat(objs.x) ~= other.x,2);
        end
        function tf = eq(objs,other)
            tf = all(vertcat(objs.x) == other.x,2);
        end
        function obj = mutation(obj,population)
            abc = randsample(population,3);
            X_mutated = abc(1).x + obj.F * (abc(2).x-abc(3).x);
            r = rand(1,length(obj.x));
            X = obj.x .* (r>=obj.CR) + X_mutated .* (r<obj.CR);
            X = max(obj.l,min(X,obj.u));
            [Objective,Infeasibility] = obj.fcn(X);
            if rand<0.5 || ((Infeasibility <= obj.infeasibility) && (Objective < obj.objective))
                obj.x = X;
                obj.infeasibility=Infeasibility;
                obj.objective = Objective;
            end
        end
        function tf = dominates(obj,other)
            tf = (obj.infeasibility<=other.infeasibility)&&(obj.objective<other.objective);
        end
        function [M,I] = best(objs)
            infeasibilities = horzcat(objs.infeasibility);
            [~,I] = min(infeasibilities);
            M = objs(I);
            for i = find(infeasibilities==M.infeasibility)
                if objs(i).objective < M.objective
                    M = objs(i);
                    I = i;
                end
            end
        end
    end
end

