%{
/*
 * Copyright 2016-2018 Leo McCormack
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

/**
 * @file saf_utility_sensorarray_presets.c
 * @ingroup Utilities
 * @brief A collection of microphone array sensor directions
 *
 * @author Leo McCormack
 * @date 11.07.2016
 * @license ISC
 */
%}
classdef MicArrayPresets
    properties (Constant)
        %% note
        %{
/* ========================================================================== */
/*                 Microphone/Hydrophone Array Configurations                 */
/* ========================================================================== */
/*
 * NOTE: All microphone array sensor directions are given in radians, and in
 * the [azimuth, elevation] convention. [0 0] is looking directly in-front
 * (positive x-axis), with positive elevations looking upwards (positive z-axis)
 * and positive azimuth angles looking leftwards (positive y-axis).
 * In other words: the convention used by SAF follows the "right-hand-rule".
 */
        %}
        %% First Order Arrays
        Sennheiser_Ambeo_maxOrder = 1;
        Sennheiser_Ambeo_radius = 0.014;
        Sennheiser_Ambeo_sphType = 'open';
        Sennheiser_Ambeo_coords_rad =...
            [ [ 0.785398163397448,    0.615472907423280];
            [ -0.785398163397448,    -0.615472907423280];
            [ 2.35619449019235,    -0.615472907423280];
            [ -2.35619449019235,    0.615472907423280]];
        
        %% Fourth Order Arrays
        Eigenmike32_maxOrder = 4;
        Eigenmike32_radius = 0.042;
        Eigenmike32_sphType = 'rigid';
        Eigenmike32_coords_rad =...
            [ [ 0.0,    0.366519142918809];
            [ 0.558505360638186,    0.0];
            [ 0.0,    -0.366519142918809];
            [ 5.72467994654140,    0.0];
            [ 0.0,    1.01229096615671];
            [ 0.785398163397448,    0.610865238198015];
            [ 1.20427718387609,    0.0];
            [ 0.785398163397448,    -0.610865238198015];
            [ 0.0,    -1.01229096615671];
            [ 5.49778714378214,    -0.610865238198015];
            [ 5.07890812330350,    0.0];
            [ 5.49778714378214,    0.610865238198015];
            [ 1.58824961931484,    1.20427718387609];
            [ 1.57079632679490,    0.558505360638186];
            [ 1.57079632679490,    -0.541052068118242];
            [ 1.55334303427495,    -1.20427718387609];
            [ 3.14159265358979,    0.366519142918809];
            [ 3.70009801422798,    0.0];
            [ 3.14159265358979,    -0.366519142918809];
            [ 2.58308729295161,    0.0];
            [ 3.14159265358979,    1.01229096615671];
            [ 3.92699081698724,    0.610865238198015];
            [ 4.34586983746588,    0.0];
            [ 3.92699081698724,    -0.610865238198015];
            [ 3.14159265358979,    -1.01229096615671];
            [ 2.35619449019235,    -0.610865238198015];
            [ 1.93731546971371,    0.0];
            [ 2.35619449019235,    0.610865238198015];
            [ 4.69493568786475,    1.20427718387609];
            [ 4.71238898038469,    0.558505360638186];
            [ 4.71238898038469,    -0.55850536063818];
            [ 4.72984227290463,    -1.20427718387609] ];
        
        %% Sixth Order Arrays
        Eigenmike64_maxOrder = 6;
        Eigenmike64_radius = 0.042;
        Eigenmike64_sphType = 'rigid';
        Eigenmike64_coords_rad =...
            [ [ -2.83692560148225,    1.27818164880864];
            [ 2.01993867482643,    1.18738794933152];
            [ 1.42961634014386,    0.830880325114551];
            [ -0.814035614228493,    1.33898773978817];
            [  0.753607262150263,    1.17508085790482];
            [  0.815634424997044,    0.651139022245491];
            [  -0.418952897650238,    0.910956967127665];
            [  0.253767458334711,    0.813421895072473];
            [ -2.71477729173270,    0.803922605455114];
            [ -2.67834651310540,    0.343599396262020];
            [ -1.96660345308635,    0.990943988455202];
            [ -2.20230887343472,    0.523150280753850];
            [ -1.66602602449896,    0.585099200690292];
            [ 1.73951485138316,    0.392810570895863];
            [ 1.82708343861935,    -0.0571336500044491];
            [ 2.11050011009380,    0.725655941388159];
            [ 2.20806887237218,    0.208056320794959];
            [ 2.58721964178970,    0.487496236821442];
            [ 2.83856987239713,    0.895055145630697];
            [ 3.11628161452059,    0.457269706159314];
            [ 0.371257341636970,    0.345669291833749];
            [ 0.450004524141750,    -0.109013147880838];
            [ 0.835326565075983,    0.155348136618155];
            [ 0.975769172099818,    -0.280894069891106];
            [ 1.24666287855117,    0.388277323089170];
            [ 1.36994638930616,    -0.0297779005413945];
            [ -1.16551358654700,    0.872691259600038];
            [ -1.21181139686516,    0.370487347485376];
            [ -0.730675027093507,    0.508119799972446];
            [ -0.453712976313774,    0.134682529426221];
            [ -0.139229335529291,    0.470807210130074];
            [ 0.0,    0.00359493636647390];
            [ 3.03745721722058,    -0.829321085313540];
            [ -2.57051232650990,    -0.868482420537143];
            [ -1.88638894293925,    -0.789121400524508];
            [ 2.62928715370744,    -1.22806308961365];
            [ -2.07996792607925,    -1.26670693603251];
            [ -1.16828004032496,    -0.908767473331338];
            [ -0.505975003237957,    -1.24265098927081];
            [ 1.06162468874934,    -1.26670693448049];
            [ -2.32279778826235,    -0.445687554292840];
            [ -2.20041502588790,    0.0652854620406425];
            [ -2.90356113105837,    -0.454071715406469];
            [ -2.62376013004531,    -0.0930483779728184];
            [ -3.08628318369241,    -0.00111227407993030];
            [ 2.85728679049571,    -0.374458122422817];
            [ 2.73933588959435,    0.0721333206867612];
            [ 2.43354320011624,    -0.712789806508398];
            [ 2.37317521443632,    -0.219519530884480];
            [ 1.78594805598457,    -0.918696988706772];
            [ 1.96438699662769,    -0.471796987587032];
            [ 1.45117925997072,    -0.481066036077434];
            [ -0.912671269832631,    -0.451837960075445];
            [ -0.887687880304674,    0.00541076429289360];
            [ -1.42677371584095,    -0.496508187842315];
            [ -1.34436547171285,    -0.0686572133153777];
            [ -1.86493632481315,    -0.286015732283003];
            [ -1.74412879676273,    0.156187480983911];
            [ 1.04264847659325,    -0.802438797091631];
            [ 0.248257511777154,    -0.919388567523963];
            [ 0.567059357016899,    -0.535041480499131];
            [ -0.452472095586400,    -0.765910029594967];
            [ 0.0363757806038008,   -0.460052607134591];
            [ -0.435151595864718,    -0.304804133944280 ] ];
    end
    
    properties (SetAccess = private)
        maxOrder;
        radius;
        sphType;% open/rigid
        coords_rad;% [azi,ele]
        azi;
        ele;
        phi;
        theta;
    end
    
    methods
        function obj = MicArrayPresets(type,varargin)
            if strcmpi(type,'ambeo')
                obj.maxOrder = MicArrayPresets.Sennheiser_Ambeo_maxOrder;
                obj.radius = MicArrayPresets.Sennheiser_Ambeo_radius;
                obj.sphType = MicArrayPresets.Sennheiser_Ambeo_sphType;
                obj.coords_rad = MicArrayPresets.Sennheiser_Ambeo_coords_rad;
            elseif strcmpi(type,'em32')
                obj.maxOrder = MicArrayPresets.Eigenmike32_maxOrder;
                obj.radius = MicArrayPresets.Eigenmike32_radius;
                obj.sphType = MicArrayPresets.Eigenmike32_sphType;
                obj.coords_rad = MicArrayPresets.Eigenmike32_coords_rad;
            elseif strcmpi(type,'em64')
                obj.maxOrder = MicArrayPresets.Eigenmike64_maxOrder;
                obj.radius = MicArrayPresets.Eigenmike64_radius;
                obj.sphType = MicArrayPresets.Eigenmike64_sphType;
                obj.coords_rad = MicArrayPresets.Eigenmike64_coords_rad;
            elseif strcmpi(type,'ESMA')
                [obj.coords_rad,obj.radius,obj.sphType,obj.maxOrder] = ...
                    getESMAMicPos(varargin{:});
            elseif strcmpi(type,'ESMA2')
                [obj.coords_rad,obj.radius,obj.sphType,obj.maxOrder] = ...
                    getESMAMicPos(varargin{:});
                obj.radius = 0.065;
            elseif strcmpi(type,'ESMA3')
                [obj.coords_rad,obj.radius,obj.sphType,obj.maxOrder] = ...
                    getESMAMicPos2(varargin{:});
                obj.radius = 0.065;
            else
                error('No such type.');
            end
            obj.azi = obj.coords_rad(:,1);
            obj.ele = obj.coords_rad(:,2);
            obj.phi = obj.azi;
            obj.theta = pi/2-obj.ele;
        end
    end
    
    methods (Static)
        function plot(type)
            if strcmpi(type,'ambeo')
                [x,y,z] = sph2cart(MicArrayPresets.Sennheiser_Ambeo_coords_rad(:,1),MicArrayPresets.Sennheiser_Ambeo_coords_rad(:,2),MicArrayPresets.Sennheiser_Ambeo_radius);
                plot3(x,y,z,'o');
                title(['maxOrder: ',num2str(MicArrayPresets.Sennheiser_Ambeo_maxOrder)]);
            elseif strcmpi(type,'em32')
                [x,y,z] = sph2cart(MicArrayPresets.Eigenmike32_coords_rad(:,1),MicArrayPresets.Eigenmike32_coords_rad(:,2),MicArrayPresets.Eigenmike32_radius);
                plot3(x,y,z,'o');
                title(['maxOrder: ',num2str(MicArrayPresets.Eigenmike32_maxOrder)]);
            elseif strcmpi(type,'em64')
                [x,y,z] = sph2cart(MicArrayPresets.Eigenmike64_coords_rad(:,1),MicArrayPresets.Eigenmike64_coords_rad(:,2),MicArrayPresets.Eigenmike64_radius);
                plot3(x,y,z,'o');
                title(['maxOrder: ',num2str(MicArrayPresets.Eigenmike64_maxOrder)]);
           else
                error('No such type.');
            end
            grid on;
            axis equal;
            xlabel('x');
            ylabel('y');
            zlabel('z');
        end
    end
end
