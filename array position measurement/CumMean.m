classdef CumMean < matlab.System
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        eleNum;
        eleMean;
        dMean;
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.eleNum = 0;
            obj.eleMean = 0;
            obj.dMean = 0;
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            eleSum = obj.eleMean.*obj.eleNum;
            obj.eleNum = obj.eleNum+1;
            eleSum = eleSum+u;
            y = eleSum./obj.eleNum;
            obj.dMean = y-obj.eleMean;
            obj.eleMean = y;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.eleNum = 0;
            obj.eleMean = 0;
            obj.dMean = 0;
        end
    end
end
