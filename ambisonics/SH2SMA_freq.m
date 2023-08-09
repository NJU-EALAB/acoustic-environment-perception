classdef SH2SMA_freq < matlab.System
    % SH2SMA_freq Sphere harm signal to sphere microphone array signal
    % in frequency domain
    %

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        micParams;
        maxSHOrder;
        freq;
        c = 343;% speed of sound [m/s]
        sphHarmType = 'complex';
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(SetAccess = private)
        YT;
        radialFiltersFR;
    end

    methods
        % Constructor
        function obj = SH2SMA_freq(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},'micParams','maxSHOrder','freq','c')
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            %% get YT
            Y = getSH(obj.maxSHOrder,[obj.micParams.phi(:),obj.micParams.theta(:)],obj.sphHarmType);
            obj.YT = Y.';
            %% get radialFiltersFR
            obj.radialFiltersFR = zeros((obj.maxSHOrder+1).^2,numel(obj.freq));
            obj.freq = obj.freq(:).';
            for n = 0:obj.maxSHOrder
                % NOTE: gain (4*pi) in bn is omit 
                if strcmpi(obj.micParams.sphType,'open')
                    bn = 1i^n.*sphbesselj(n,2*pi/obj.c*obj.micParams.radius*obj.freq);
                elseif strcmpi(obj.micParams.sphType,'rigid')
                    bn = 1i^n.*sphbesseljR(n,2*pi/obj.c*obj.micParams.radius*obj.freq,2*pi/obj.c*obj.micParams.radius*obj.freq);
                else
                    error('No such sphType.');
                end
                bn = (-1)^n*conj(bn);
                obj.radialFiltersFR(n^2+1:(n+1)^2,:) = repmat(bn,2*n+1,1);
            end
            obj.radialFiltersFR = reshape(obj.radialFiltersFR,1,(obj.maxSHOrder+1).^2,numel(obj.freq));
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(size(u,2)==(obj.maxSHOrder+1).^2);
            y = pagemtimes(u.*obj.radialFiltersFR,obj.YT);
            % y: dim1 frame; dim2 SH; dim3 freq
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

    end
end

