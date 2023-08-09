function sparseDoaSH(sh,sphHarmType)
[~, azel] = getTdesign(21);
azel = azel.';
[IRLen,shNum] = size(sh,[1 2]);
% azel = getMesh(azimuth,elevation);
maxOrder = sqrt(shNum)-1;
assert(mod(maxOrder,1)==0);
Y = conj(getSH(maxOrder,[azel(1,:).',pi/2-azel(2,:).'],sphHarmType));

A = Y.';
B = sh(5001:6000,:).';
win = hamming(2*size(B,2));
B = B.*(win(end/2+1:end,1).');
X0 = zeros(size(A,2),size(B,2));
gamma = 0.01;
itermax = 100000;
tol = 1e-6;
groupL = 1;
[X] = fistaGL(A,B,X0,gamma,tol,itermax,groupL,azel);% min 1/2*||B-A*X||^2_F+gamma*||X||_(2,1)
end

%%
%%
function [X] = fistaGL(A,B,X0,gamma,tol,itermax,groupL,azel)
% multi-target group lasso using FISTA
% min 1/2*||B-A*X||^2_F+gamma*||X||_(2,1)
% every groupL rows of X belong to a group
%% init
if nargin<7 groupL = 1;end%#ok
if nargin<6 itermax = 10000;end%#ok
if nargin<5 tol = 1e-6;end%#ok

[M,N,~] = size(A);
assert(size(B,1) == M);
O = size(B,2);
assert(all(size(X0) == [N,O]));
assert(abs(round(N/groupL)-N/groupL)<1e-12);

%%
% L = O*max(eig(A'*A));
L = real(O*maxEig(A'*A));
tL = 1/L;

t0 = 1;% t_k
Y0 = X0;% y_k; x_k-1

figure;
RGB = parula(41);
% RGB = flipud(RGB);
for ii = 1:itermax
    X = soft2(Y0-tL*A'*(A*Y0-B),tL*gamma,groupL);
    %%% let small row of X = 0
    pow_dB = 0.5*mag2db(vecnorm(X,2,2).^2);
    pow_dB = pow_dB-max(pow_dB);
    X(pow_dB<-40,:) = 0;
    %%%
    t = (1+sqrt(1+4*t0.^2))./2;
    Y = X+(t0-1)./t.*(X-X0);
    tol0 = norm(X-X0,'fro')/norm(X0,'fro');
    X0 = X;
    Y0 = Y;
    t0 = t;
    %%% plot
    if ~mod(ii,100)
        cla;
        for jj = 1:size(azel,2)
            pow_dB = max(-40,pow_dB);
            [x,y,z] = sph2cart(azel(1,jj),azel(2,jj),pow_dB(jj)+40);
            plot3([0 x],[0 y],[0 z],'Color',RGB(round(pow_dB(jj)+41),:),'LineWidth',3);   
            hold on;
        end
        axis equal
        grid on
        xlabel('x');
        ylabel('y');
        view([0 90]);
        drawnow limitrate
    end
    %%%
    if isnan(tol0)
        fprintf('converged at %dth iterations. X == 0\n',ii);
        break;
    end
    if tol0 < tol
        fprintf('converged at %dth iterations\n',ii);
        break;
    end
    disp(ii);
    disp(tol0);
end
if ii == itermax
    fprintf('reached max iterations: %d. tol: %f.\n',ii,tol0);
end
end

%%
%%
function Y = soft2(X0,T,groupL)
% every groupL rows of X0 belong to a group
N = size(X0,1);
G = round(N/groupL);
assert(abs(G-N/groupL)<1e-12);
assert(all(size(T)==[1 1]));
Y = 0*X0;

for g = 1:G
    range = (g-1)*groupL+1:g*groupL;
    X = X0(range,:);
    K = max(norm(X,'fro') - T, 0);
    Y(range,:) = K./(K+T) .* X;
end
end


