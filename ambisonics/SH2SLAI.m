classdef SH2SLAI < matlab.System
    % SH2SLAI Get spatially-localised active-intensity (SLAI) using sphere harm signal
    %

    % Public, tunable properties
    properties

    end

    % Public, non-tunable properties
    properties(Nontunable)
        sectorAzimuth;
        sectorElevation;
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
        Wpu;
    end

    methods
        % Constructor
        function obj = SH2SLAI(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},'sectorAzimuth','sectorElevation','maxOrder','lowPassFilterParams','patternWeight')
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
            elseif strcmpi(obj.patternWeight,'omni')
                obj.patternWeight = [1,zeros(1,obj.maxOrder)];
            else
                assert(isnumeric(obj.patternWeight));
            end
            assert(numel(obj.patternWeight)==obj.maxOrder+1);
            obj.YWeight = zeros(1,(obj.maxOrder+1)^2);
            for n = 0:obj.maxOrder
                obj.YWeight(n^2+1:(n+1)^2) = obj.patternWeight(n+1);
            end
            %% get YT
            assert(numel(obj.sectorAzimuth)==numel(obj.sectorElevation));
            obj.YT = (obj.YWeight.*getSH(obj.maxOrder,[obj.sectorAzimuth(:),pi/2-obj.sectorElevation(:)],obj.sphHarmType)).';
            %% get Wpu
            load('velCoeffsMtx_N20.mat','A_xyz');
            assert(strcmpi(obj.sphHarmType,'complex'));
            A = conj(A_xyz(1:(obj.maxOrder+2)^2,1:(obj.maxOrder+1)^2,:));
            obj.Wpu(:,:,1) = [obj.YT;zeros(2*obj.maxOrder+3,size(obj.YT,2))];
            obj.Wpu(:,:,2) = A(:,:,1)*obj.YT;
            obj.Wpu(:,:,3) = A(:,:,2)*obj.YT;
            obj.Wpu(:,:,4) = A(:,:,3)*obj.YT;
            obj.Wpu = permute(obj.Wpu,[1 3 2]); % Wpu: dim1 weight; dim2 wxyz; dim3 sector
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
%                 obj.lowPassFilter(zeros(2,(obj.maxOrder+2)^2));
            elseif strcmpi(obj.lowPassFilterParams.status,'off')
                obj.lowPassFilter = @(x)x;
            else
                error('No such obj.lowPassFilterParams.status');
            end
        end

        function [wxyz,azel] = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            assert(size(u,2)==(obj.maxOrder+2)^2);
            % y: dim1 frame; dim2 pu; dim3 sector
            wxyz = pagemtimes(obj.lowPassFilter(u),obj.Wpu);
            
            sndIntSeries = real(wxyz(:,1,:).*conj(wxyz(:,2:4,:)));
            I = squeeze(sum(sndIntSeries,1));
            if size(I,1) == 1
                I = I.';
            end
            [azel(:,1),azel(:,2)] = cart2sph(I(1,:),I(2,:),I(3,:));
            
%             xyz1 = sqrt(2*pi/3)*[1 1i 0;0 0 sqrt(2);-1 1i 0];
%             ai = pagemtimes(obj.lowPassFilter(u),obj.Wpu);
%             sndIntSeries = real(slai(:,1,:).*conj(slai(:,2:4,:)));
%             I = squeeze(sum(sndIntSeries,1));
%             [azel(:,1),azel(:,2)] = cart2sph(I(1,:),I(2,:),I(3,:));
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            if strcmpi(obj.lowPassFilterParams.status,'on')
                obj.lowPassFilter.reset;
            end
        end

    end
end
