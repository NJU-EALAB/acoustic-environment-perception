classdef SH2SRP < matlab.System
    % SH2SRP Get steered response power using sphere harm signal
    %

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        azimuth;
        elevation;
        maxOrder;
        lowPassFilterParams;
        patternWeight;
        sphHarmType = 'real';
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(SetAccess = private)
        YT;
        YWeight;
        lowPassFilter;
    end

    methods
        % Constructor
        function obj = SH2SRP(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},'azimuth','elevation','maxOrder','lowPassFilterParams','patternWeight')
        end
        
        function fvtool(obj)
            if ~isLocked(obj)
                obj.setup;
            end
            obj.lowPassFilter.fvtool;
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            %% get patternWeight
            % Eq. (16) in doi: 10.17743/jaes.2019.0041
            if isempty(obj.patternWeight)
                obj.patternWeight = ones(1,obj.maxOrder+1);
            end
            L = obj.maxOrder;
            l = 0:L;
            if strcmpi(obj.patternWeight,'cardioid')
                obj.patternWeight = factorial(L).^2./factorial(L+l+1)./factorial(L-l);
            elseif strcmpi(obj.patternWeight,'hypercardioid')
                obj.patternWeight = repmat((L+1).^-2,1,L+1);
            elseif strcmpi(obj.patternWeight,'max-rE')
                obj.patternWeight = todo;
            else
                assert(isnumeric(obj.patternWeight));
            end
            assert(numel(obj.patternWeight)==obj.maxOrder+1);
            obj.YWeight = zeros(1,(obj.maxOrder+1)^2);
            for n = 0:obj.maxOrder
                obj.YWeight(n^2+1:(n+1)^2) = obj.patternWeight(n+1);
            end
            %% get YT
            azel = getMesh(obj.azimuth,obj.elevation);
            obj.YT = (obj.YWeight.*getSH(obj.maxOrder,[azel(1,:).',pi/2-azel(2,:).'],obj.sphHarmType)).';
            %% get lowPassFilter
            if strcmpi(obj.lowPassFilterParams.status,'on')
                filtertype = 'FIR';            
                Rp = 0.1;
                Astop = 40;
                obj.lowPassFilter = dsp.LowpassFilter(...
                    'DesignForMinimumOrder',false, ...
                    'SampleRate',obj.lowPassFilterParams.fs, ...
                    'FilterType',filtertype, ...
                    'FilterOrder',obj.lowPassFilterParams.filterOrder, ...
                    'PassbandFrequency',obj.lowPassFilterParams.maxFreq, ...
                    'PassbandRipple',Rp, ...
                    'StopbandAttenuation',Astop);
%                 obj.lowPassFilter(zeros(2,(obj.maxOrder+1)^2));
            elseif strcmpi(obj.lowPassFilterParams.status,'off')
                obj.lowPassFilter = @(x)x;
            else
                error('No such obj.lowPassFilterParams.status');
            end
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = reshape(0.5*mag2db( ...
                vecnorm(obj.lowPassFilter(u)*obj.YT).^2./size(u,1) ...
                ),length(obj.elevation),length(obj.azimuth));
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            if strcmpi(obj.lowPassFilterParams.status,'on')
                obj.lowPassFilter.reset;
            end
        end

    end
end
