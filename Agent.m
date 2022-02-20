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
            tf = any(vertcat(objs.x) == other.x,2);
        end
        function obj = mutation(obj,population)
            a = randsample(population,1);
            while a == obj
                a = randsample(population,1);
            end
            b = randsample(population,1);
            while b == obj || b == a
                b = randsample(population,1);
            end
            c = randsample(population,1);
            while c == obj || c == a || c == b
                c = randsample(population,1);
            end
            X = obj.x;
            R = randsample(1:length(X),1);
            for i =1:length(X)
                if rand < obj.CR || i == R
                    X(i)=a.x(i) + obj.F * (b.x(i)-c.x(i));
                end
            end
            X = max(obj.l,min(X,obj.u));
            [Objective,Infeasibility] = obj.fcn(X);
            if (Infeasibility <= obj.infeasibility) && (Objective < obj.objective)
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
                if objs(i).dominates(M)
                    M = objs(i);
                    I = i;
                end
            end
        end
    end
end

