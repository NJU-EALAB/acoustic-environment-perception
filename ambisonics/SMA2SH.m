classdef SMA2SH < matlab.System
    % SMA2SH Sphere microphone array signal to sphere harm signal
    %

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        micParams;
        maxGain_dB;
        fs;
        filterOrder;
        c = 343;% speed of sound [m/s]
        sphHarmType = 'real';
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(SetAccess = private)
        invYT;
        radialFiltersIR;
        radialFilters;        
    end

    methods
        % Constructor
        function obj = SMA2SH(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},'micParams','maxGain_dB','fs','filterOrder','c')
        end
        
        function fvtool(obj)
            if ~isLocked(obj)
                obj.setup;
            end
            for idx = 1:size(obj.radialFiltersIR,1)
                fvtool(obj.radialFiltersIR(idx,:));
            end
        end
    end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            %% get invYT
            Y = getSH(obj.micParams.maxOrder,[obj.micParams.phi(:),obj.micParams.theta(:)],obj.sphHarmType);
            assert(size(Y,1)>=size(Y,2),'The number of sensors cannot be less than (maxOrder+1)^2.');
            obj.invYT = (pinv(Y'*Y)*Y').';% note: u_sh = u_array*obj.invYT
            %% get radialFiltersIR
            obj.radialFiltersIR = zeros(obj.micParams.maxOrder+1,obj.filterOrder+1);
            regCoeff = 1./(2*db2mag(obj.maxGain_dB)).^2;% lambda^2
            for n = 0:obj.micParams.maxOrder
                % NOTE: gain (4*pi) in bn is omit 
                if strcmpi(obj.micParams.sphType,'open')
                    bn = @(fn)1i^n.*sphbesselj(n,2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn);
                elseif strcmpi(obj.micParams.sphType,'rigid')
                    bn = @(fn)1i^n.*sphbesseljR(n,2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn,2*pi*obj.fs/2/obj.c*obj.micParams.radius*fn);
                else
                    error('No such sphType.');
                end
                bn = @(fn)(-1)^n*conj(bn(fn));
                wn = @(fn)(abs(bn(fn)).^2./(abs(bn(fn)).^2+regCoeff))./bn(fn);
                obj.radialFiltersIR(n+1,:) = fr2ir(wn,obj.filterOrder);
            end
            %% get radialFilters
            obj.radialFilters = cell((obj.micParams.maxOrder+1).^2,1);
            idx = 1;
            for n = 0:obj.micParams.maxOrder
                for m = -n:n% TODO: only using (maxOrder+1) filter. (remove m)
                    obj.radialFilters{idx} = dsp.FIRFilter(obj.radialFiltersIR(n+1,:));
%                     obj.radialFilters{idx}(zeros(2,1));% TODO: only using (maxOrder+1) filter. (zeros(2,2*n+1))
                    idx = idx+1;
                end
            end
            assert(idx==(obj.micParams.maxOrder+1).^2+1);
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            x = u*obj.invYT;
            y = zeros(size(x));
            for idx = 1:length(obj.radialFilters)
                y(:,idx) = obj.radialFilters{idx}(x(:,idx));
            end
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            for idx = 1:length(obj.radialFilters)
                obj.radialFilters{idx}.reset;
            end
        end

    end
end
