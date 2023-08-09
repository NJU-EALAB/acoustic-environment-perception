classdef SH2SMA < matlab.System
    % SH2SMA Sphere harm signal to sphere microphone array signal
    %

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        micParams;
        maxSHOrder;
        fs;
        filterOrder;
        c = 343;% speed of sound [m/s]
        sphHarmType = 'real';
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(SetAccess = private)
        YT;
        radialFiltersIR;
        radialFilters;        
    end

    methods
        % Constructor
        function obj = SH2SMA(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},'micParams','maxSHOrder','fs','filterOrder','c')
        end
        
        function fvtool(obj)
            if ~isLocked(obj)
                obj.setup;
            end
            for idx = 1:size(obj.radialFiltersIR,1)
                fvtool(obj.radialFiltersIR(idx,:),'Fs',obj.fs);
            end
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            %% get YT
            Y = getSH(obj.maxSHOrder,[obj.micParams.phi(:),obj.micParams.theta(:)],obj.sphHarmType);
            obj.YT = Y.';
            %% get radialFiltersIR
            obj.radialFiltersIR = zeros(obj.maxSHOrder+1,obj.filterOrder+1);
            for n = 0:obj.maxSHOrder
                % NOTE: gain (4*pi) in bn is omit 
                if strcmpi(obj.micParams.sphType,'open')
                    bn = @(fn)1i^n.*sphbesselj(n,2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn);
                elseif strcmpi(obj.micParams.sphType,'rigid')
                    bn = @(fn)1i^n.*sphbesseljR(n,2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn,2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn);
                else
                    error('No such sphType.');
                end
                %%% test bn and sph harm function
                bn = @(fn)(-1)^n*conj(bn(fn));
                if 0
                    fn = 1000;
                    kR = 2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn;
                    bN = sphModalCoeffs(n, kR, 'rigid')/(4*pi);
                    bn1 = bn(fn);
                    bn2 = bN(:,end);
                end
                %%%
                obj.radialFiltersIR(n+1,:) = fr2ir(bn,obj.filterOrder);
            end
            %% get radialFilters
            obj.radialFilters = cell((obj.maxSHOrder+1).^2,1);
            idx = 1;
            for n = 0:obj.maxSHOrder
                for m = -n:n
                    obj.radialFilters{idx} = dsp.FIRFilter(obj.radialFiltersIR(n+1,:));
%                     obj.radialFilters{idx}(zeros(2,1));
                    idx = idx+1;
                end
            end
            assert(idx==(obj.maxSHOrder+1).^2+1);
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(size(u,2)==(obj.maxSHOrder+1).^2);
            x = zeros(size(u));
            for idx = 1:length(obj.radialFilters)
                x(:,idx) = obj.radialFilters{idx}(u(:,idx));
            end
            y = x*obj.YT;

        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            for idx = 1:length(obj.radialFilters)
                obj.radialFilters{idx}.reset;
            end
        end

    end
end

