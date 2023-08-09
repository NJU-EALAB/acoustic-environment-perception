% dirplot_demo.m


%% beam pattern
G = SpkDir.freqData.';
phi = SpkDir.channelCoordinates.phi_deg;
N_phi = length(phi);
f = SpkDir.wavenumber*343/(2*pi);
N_f = length(f);

p = G./max(G);
phi0 = repmat(phi,1,N_f); f0 = repmat(f',N_phi,1);
figure
surf(f0,phi0,mag2db(abs(p)));
view(0,90);
set(gca,'xscale','log');
xlim([100,20000]); ylim([-90,90]);
% set(gca,'xdir','reverse');
% colormap('lines');
caxis([-10,0]);
colorbar;
colormap('jet')
shading interp;

%%
% Demonstrates usage of DIRPLOT.M to generate polar
% directivity plots.

% Generate a couple of sample curves on -90 to +90
% degrees and plot on the same graph with autoscaling.
% phi = start_phi:dAngle:end_phi;
% rho1 = -20 + 20*(cos(phi*pi/180)).^2;
% rho2 = -20 + 18*cos(phi*pi/180);
% dirplot(phi,rho1,'b');
% hold
% dirplot(phi,rho2,'r');
% title('Semicircular Plot Example');
% legend('rho1','rho2');
% 
% % Now plot the difference 
% figure;
% rho3 = rho1 - rho2;
% dirplot(theta,rho3);
% title('Difference Plot');
% 
% % Now generate a cardiod pattern in a full plot.
% % We know what we want to see, so we'll scale manually.
% figure;
% theta = -180:5:180;
% rho = 1 + cos(theta*pi/180);
% dirplot(theta,rho,[2 0 5]);
% title('Full Polar Plot of Cardiod');


