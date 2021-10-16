function [Xw, Yw]= tpswarp_rewrite(Vs,Zp,Zs)
% VS=[x(:),y(:)];
% number of landmark points
NPs = size(Zp,1); 
% landmark in input
Xp = Zp(:,2);
Yp = Zp(:,1);
% landmark in output (homologous)
Xs = Zs(:,2);
Ys = Zs(:,1);

%% Algebra of Thin-plate splines
% Compute thin-plate spline mapping [W|a1 ax ay] using landmarks
[wL]=computeWl(Xp, Yp, NPs);% N+3 by N+3
wY = [Xs,Ys; zeros(3,2)]; % N+3 by 2 Y = ( V| 0 0 0)'   where V = [G] where G is landmark homologous (nx2) ; Y is col vector of length (n+3)
wW = wL\wY;%wW = inv(wL)*wY; %N+3 by 2 (W|a1 ax ay)' = inv(L)*Y
% Thin-plate spline mapping (Map all points in the plane)
% f(x,y) = a1 + ax * x + ay * y + SUM(wi * U(|Pi-(x,y)|)) for i = 1 to n
[Xw, Yw]=tpsMap(wW,Xp,Yp,NPs,Vs);
return

%% [L] = [[K P];[P' 0]]
function [wL]=computeWl(xp, yp, np)
% 1xNp to NpxNp
rXp = repmat(xp,1,np); 
rYp = repmat(yp,1,np); 
% compute r(i,j)
wR = sqrt((rXp-rXp').^2 + (rYp-rYp').^2); 
wK = radialBasis(wR); % compute [K] with elements U(r)=r^2 * log (r^2)
wP = [ones(np,1),xp,yp]; % [P] = [1 xp' yp'] where (xp',yp') are n landmark points (nx2)
wL = [wK,wP;wP',zeros(3,3)]; % [L] = [[K P];[P' 0]]
return

%% k=(r^2) * log(r^2)
function [ko]=radialBasis(ri)
r_i = ri;
r_i(ri==0)=realmin; % Avoid log(0)=inf
ko = 2*(ri.^2).*log(r_i);
return

%% Mapping: f(x,y) = a1 + ax * x + ay * y + SUM(wi * U(|Pi-(x,y)|)) for i = 1 to n
% np - number of landmark points
% (xp, yp) - coordinate of landmark points
function [Xw, Yw]=tpsMap(wW,xp,yp,np,Vs)
% total number of points in the plane
Vs=Vs(:,end:-1:1)';
NWs = size(Vs,2);
% all points in plane %np x NWs
rX = repmat(Vs(1,:),np,1);
rY = repmat(Vs(2,:),np,1);
% landmark points %np x NWs
rxp = repmat(xp,1,NWs);
ryp = repmat(yp,1,NWs);
% Mapping Algebra %np x NWs
wR = sqrt((rxp-rX).^2 + (ryp-rY).^2);% distance measure r(i,j)=|Pi-(x,y)|
wK = radialBasis(wR); % compute [K] with elements U(r)=r^2 * log (r^2)
wP = [ones(1,NWs);Vs(1,:);Vs(2,:)]; %3 x NWs [P] = [1 x' y'] where (x',y') are n landmark points (nx2)
wL = [wK;wP]'; %NWs x Np+3 [L] = [[K P];[P' 0]]
Pw  = wL*wW; % NWs x 2 [Pw] = [L]*[W]
Xw  = Pw(:,2);
Yw  = Pw(:,1);
return