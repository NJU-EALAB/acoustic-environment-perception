classdef PW2SH < matlab.System
    % PW2SH Plane wave signal to Sphere harm signal
    %

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        maxSHOrder;
        sphHarmType = 'real';
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(SetAccess = private)
        Y;     
    end

    methods
        % Constructor
        function obj = PW2SH(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},'maxSHOrder')
        end

    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function y = stepImpl(obj,u,azimuth,elevation)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(size(u,2)==numel(azimuth));
            assert(size(u,2)==numel(elevation));

            obj.Y = conj(getSH(obj.maxSHOrder,[azimuth(:),pi/2-elevation(:)],obj.sphHarmType));
            y = u*obj.Y;

        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties

        end

    end
end
