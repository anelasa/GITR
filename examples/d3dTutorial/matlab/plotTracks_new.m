clear all
close all
% M = csvread('iterGeom.csv');
% r = M(:,1);
% z = M(:,2);
% rGeom = r;
% zGeom = z;
fid = fopen('../input/gitrGeometry.cfg');

tline = fgetl(fid);
tline = fgetl(fid);
for i=1:19
    tline = fgetl(fid);
    evalc(tline);
end
Zsurface = Z;
surfaces = find(surface);
nSurfaces = length(a);
%Section for finding a subset of planes to plot
r = sqrt(x1.^2 + y1.^2);
subset = 1:1:length(Z);
subset = find(surface);
%subset = find(r<0.049 & z1 > -0.001 & z1<0.001)
figure(1)
X = [transpose(x1(subset)),transpose(x2(subset)),transpose(x3(subset))];
Y = [transpose(y1(subset)),transpose(y2(subset)),transpose(y3(subset))];
Z = [transpose(z1(subset)),transpose(z2(subset)),transpose(z3(subset))];
%patch(transpose(X(surface,:)),transpose(Y(surface,:)),transpose(Z(surface,:)),impacts(surface),'FaceAlpha',.3)
patch(transpose(X),transpose(Y),transpose(Z),'Green','FaceAlpha',.3,'EdgeAlpha', 0.3)%,impacts(surface)
title('Deposited Impurity Mass (per face) log scale [g]')
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')

set(gca,'fontsize',16)

hold on
%%figure(10)
file = '../output/history.nc';
x = ncread(file,'x');
y = ncread(file,'y');
z = ncread(file,'z');
r=sqrt(x.^2 + y.^2);
nT=10001; %ncread(file,'nT');
nP=1000; %ncread(file,'nP');
%vx = ncread(file,'vx');
%vy = ncread(file,'vy');
%vz = ncread(file,'vz');
charge = ncread(file,'charge');
weight = ncread(file,'weight');
sizeArray = size(x);
nP = sizeArray(2);
hit = find(weight(end,:) < 1);

%r_geom = config['geom']['x1'];
%z_geom = config['geom']['z1'];
r_geom=x1;
z_geom=z1;

%if plot ==1:
%    plt.close()
%    plt.figure(1,figsize=(6, 10), dpi=60)
%	if(x.shape[0] ==1):
%        plt.plot(r[0][:],z[0][:],linewidth=5,color='green')
%	else:

%for i =1:nP
%    plot(r(i,:),z(i,:))
%end
%    end
%end

%%figure(1)
hold on
% i=581
% plot(r(:,i),z(:,i))
%41242
for i=1:nP %1000
 
%plot(r(:,i),z(:,i))
plot3(x(:,i),y(:,i),z(:,i))
end
xlabel('X')
ylabel('Y')
zlabel('Z')
% plot(rGeom,zGeom)
% hold on
% scatter(rGeom,zGeom)
axis equal
%readIterGeom