close all
clear all
nP = 1.0e5; 
fid = fopen('../input/gitrGeometry.cfg');

%launch particles a little (~1e-5 [m]) away from the surface  
launch_d=1.0e-5;

tline = fgetl(fid);
tline = fgetl(fid);
for i=1:19
    tline = fgetl(fid);
    evalc(tline);
end
Zsurface = Z;
sources = find(Zsurface); %same as writing find(Zsurface>0)
nSurfaces = length(a);
%Section for finding a subset of planes to plot
%noneed r = sqrt(x1.^2 + y1.^2);
%noneed subset = 1:1:length(Z);
%noneed subset = find(r<0.049 & z1 > -0.001 & z1<0.001)
subset = sources;
figure(2)
X = [transpose(x1(subset)),transpose(x2(subset)),transpose(x3(subset))];
Y = [transpose(y1(subset)),transpose(y2(subset)),transpose(y3(subset))];
Z = [transpose(z1(subset)),transpose(z2(subset)),transpose(z3(subset))];
%patch(transpose(X(surface,:)),transpose(Y(surface,:)),transpose(Z(surface,:)),impacts(surface),'FaceAlpha',.3)
patch(transpose(X),transpose(Y),transpose(Z),'Green','FaceAlpha',.3,'EdgeAlpha', 0.3)%,impacts(surface)
title('Impurity source')
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')

set(gca,'fontsize',16)

total_area = sum(area(sources));
particles_per_triangle = floor(nP*area(sources)./total_area);

missing_particles = nP-sum(particles_per_triangle);
particles_per_triangle(1:missing_particles) = particles_per_triangle(1:missing_particles)+1;
xP = [];
yP = [];
zP = [];
disp('test: particles_per_triangle')
disp(particles_per_triangle)
for i=1:length(particles_per_triangle)
    np_this_triangle = particles_per_triangle(i);
    point1 = [x1(sources(i)),y1(sources(i)),z1(sources(i))];
    point2 = [x2(sources(i)),y2(sources(i)),z2(sources(i))];
    point3 = [x3(sources(i)),y3(sources(i)),z3(sources(i))];
    disp('test: i, np, point1, point2, point3')
    Sdisp=[i, np_this_triangle,point1,point2,point3];
    disp(Sdisp)
    [px,py,pz] = sample_triangle(np_this_triangle,point1,point2,point3);
    xP = [xP;px];
    yP = [yP;py];
    zP = [zP;pz];
    disp('px,py,pz')
    Sdisp2=[px,py,pz];
    disp(Sdisp2)
end

%add launch_d to z of particles; 
%here a constant value; for complex geometries, along the normal to surf
zP=zP+launch_d;

vxP = zeros(1,nP);
vyP = zeros(1,nP);
vzP = 3.0e3*ones(1,nP);

hold on
scatter3(xP,yP,zP)

ncid = netcdf.create('./particleSource.nc','NC_WRITE')
 
dimP = netcdf.defDim(ncid,'nP',nP);

xVar = netcdf.defVar(ncid,'x','double',[dimP]);
yVar = netcdf.defVar(ncid,'y','double',[dimP]);
zVar = netcdf.defVar(ncid,'z','double',[dimP]);
ExVar = netcdf.defVar(ncid,'vx','double',[dimP]);
EyVar = netcdf.defVar(ncid,'vy','double',[dimP]);
EzVar = netcdf.defVar(ncid,'vz','double',[dimP]);

netcdf.endDef(ncid);
 
netcdf.putVar(ncid, xVar, xP);
netcdf.putVar(ncid, yVar, yP);
netcdf.putVar(ncid, zVar, zP);
netcdf.putVar(ncid, ExVar, vxP);
netcdf.putVar(ncid, EyVar, vyP);
netcdf.putVar(ncid, EzVar, vzP);

netcdf.close(ncid);