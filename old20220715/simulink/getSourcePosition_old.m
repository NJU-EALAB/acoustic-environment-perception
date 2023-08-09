classdef getSourcePosition < matlab.System 
    % getSourcePosition
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        arrayPos = [0 0 0;-1 1 0;1 1 0].';
        arrayAxis = [2 0 0;0 1 0;0 0 1].';
        stepLength = 0.1;
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        sourcePos;
        N;
        arrayAxisNorm;
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.sourcePos = mean(obj.arrayPos,2);%[3x1]
            obj.N = size(obj.arrayPos,2);
            obj.arrayAxisNorm = obj.arrayAxis./repmat(vecnorm(obj.arrayAxis,2,1),3,1);
        end

        function [sourcePosition, cost] = stepImpl(obj,aoa,calFlag)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            if calFlag
            %% get cos(theta)
            costh = cos(pi/180*(90-aoa));%[1xN]
            %% get sourcePosition
            r_ri = repmat(obj.sourcePos,1,obj.N)-obj.arrayPos;%[3xN]
            r_ri_norm = vecnorm(r_ri,2,1);%[1xN]
            grad = sum(2*...
                repmat( sum(r_ri.*obj.arrayAxisNorm,1) - costh.*r_ri_norm ,3,1)...
                .*( obj.arrayAxisNorm - repmat(costh./r_ri_norm,3,1).*r_ri )...
                ,2);
            sourcePosition = obj.sourcePos - obj.stepLength*grad;
            obj.sourcePos = sourcePosition;
%             cost = sum((sum(r_ri.*obj.arrayAxisNorm,1) - costh.*r_ri_norm).^2);
            cost = grad;
            else
                sourcePosition = obj.sourcePos;
                cost = 0*obj.sourcePos;
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    end
end
