fileID = fopen('d-167196-w-a47.plasma.dat','r');
t = fgetl(fileID)
t = fgetl(fileID)
formatSpec = '%f %f %f %f %f %f %f %f %f %f %f %f %f';
sizeA = [13 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);

nZ = length(find(A(1,:) == 0));
nR = length(A(1,:))/nZ;
r_offset = 1;
z_offset = -1.45;
r = linspace(min(A(3,:)), max(A(3,:)), nR)+r_offset;
z = linspace(min(A(4,:)), max(A(4,:)), nZ)+z_offset;
dr = r(2)-r(1);
dz = z(2)-z(1);
ne = reshape(A(5,:),[nZ,nR]);

te = reshape(A(6,:),[nZ,nR]);
ti = reshape(A(7,:),[nZ,nR]);
Vpara = reshape(A(8,:),[nZ,nR]);
Epara = reshape(A(9,:),[nZ,nR]);
btot = reshape(A(10,:),[nZ,nR]);
br = reshape(A(11,:),[nZ,nR]);
bz = reshape(A(12,:),[nZ,nR]);
bt = reshape(A(13,:),[nZ,nR]);
[gradRte gradZte] = gradient(te,dr,dz);
[gradRti gradZti] = gradient(ti,dr,dz);
% bUnitR = br./btot;
% bUnitZ = bz./btot;
% dB = 0.0005;
% interpR = r+bUnitR*dB;
% interpZ = z'+bUnitZ*dB;
% t2 = interpn(r,z,ti',interpR,interpZ)
% grad2 = (t2 - ti)/dB;
vr = Vpara.*br;
vt = Vpara.*bt;
vz = Vpara.*bz;

er = Epara.*br;
et = Epara.*bt;
ez = Epara.*bz;

gradT = 0*gradRti;
figure(1)
gradRDotBr = gradRti.*br;
figure(113)
h = pcolor(r,z,ne)
h.EdgeColor = 'none';
colorbar
% set(gca, 'YDir', 'normal')
%  set(gca, 'XScale', 'log')
% colormap winter
colorbar
set(gca,'YDir','normal')
% textString = '$$ \frac{\partial{T_i}}{\partial{r}}b_r $$';
% text(1.9,1.25,textString,'Interpreter','latex','Color','White','FontSize',18)
title({'DIII-D Ion Temperature'})%,'Directional Derivative [eV/m]'})
xlabel('r [m]') % x-axis label
ylabel('z [m]') % y-axis label
set(gca,'fontsize',16)
axis equal
hold on

if (exist('x1') == 0)
    fid = fopen('../gitrD3DGeometry.cfg');
    
    tline = fgetl(fid);
    tline = fgetl(fid);
    for i=1:11
        tline = fgetl(fid);
        evalc(tline);
    end
length_line = length;
clear length
end
plot([x1 x1(end)],[z1 z1(end)],'white','LineWidth',2)
axis equal
axis([r(1) r(end) z(1) z(end)])

ncid = netcdf.create(['./profiles.nc'],'NC_WRITE')

dimR = netcdf.defDim(ncid,'nR',nR);
dimZ = netcdf.defDim(ncid,'nZ',nZ);

gridR = netcdf.defVar(ncid,'gridR','double',[dimR]);
gridZ = netcdf.defVar(ncid,'gridZ','double',[dimZ]);

neVar = netcdf.defVar(ncid, 'ne', 'double',[dimR dimZ]);
teVar = netcdf.defVar(ncid, 'te', 'double',[dimR dimZ]);
tiVar = netcdf.defVar(ncid, 'ti', 'double',[dimR dimZ]);
EparaVar = netcdf.defVar(ncid, 'Epara', 'double',[dimR dimZ]);
etVar = netcdf.defVar(ncid, 'et', 'double',[dimR dimZ]);
erVar = netcdf.defVar(ncid, 'er', 'double',[dimR dimZ]);
ezVar = netcdf.defVar(ncid, 'ez', 'double',[dimR dimZ]);
VparaVar = netcdf.defVar(ncid, 'Vpara', 'double',[dimR dimZ]);
vtVar = netcdf.defVar(ncid, 'vt', 'double',[dimR dimZ]);
vrVar = netcdf.defVar(ncid, 'vr', 'double',[dimR dimZ]);
vzVar = netcdf.defVar(ncid, 'vz', 'double',[dimR dimZ]);
btotVar = netcdf.defVar(ncid, 'btot', 'double',[dimR dimZ]);
btVar = netcdf.defVar(ncid, 'bt', 'double',[dimR dimZ]);
brVar = netcdf.defVar(ncid, 'br', 'double',[dimR dimZ]);
bzVar = netcdf.defVar(ncid, 'bz', 'double',[dimR dimZ]);
gradRteVar = netcdf.defVar(ncid, 'gradRte', 'double',[dimR dimZ]);
gradZteVar = netcdf.defVar(ncid, 'gradZte', 'double',[dimR dimZ]);
gradRtiVar = netcdf.defVar(ncid, 'gradRti', 'double',[dimR dimZ]);
gradZtiVar = netcdf.defVar(ncid, 'gradZti', 'double',[dimR dimZ]);
gradYtiVar = netcdf.defVar(ncid, 'gradYti', 'double',[dimR dimZ]);
gradYteVar = netcdf.defVar(ncid, 'gradYte', 'double',[dimR dimZ]);
gradTVar = netcdf.defVar(ncid, 'gradT', 'double',[dimR dimZ]);
netcdf.endDef(ncid);

netcdf.putVar(ncid, gridR, r);
netcdf.putVar(ncid, gridZ, z);

netcdf.putVar(ncid, neVar, ne');
netcdf.putVar(ncid, teVar, te');
netcdf.putVar(ncid, tiVar, ti');
netcdf.putVar(ncid, EparaVar, Epara');
netcdf.putVar(ncid, etVar, et');
netcdf.putVar(ncid, erVar, er');
netcdf.putVar(ncid, ezVar, ez');
netcdf.putVar(ncid, VparaVar, Vpara');
netcdf.putVar(ncid, vtVar, vt');
netcdf.putVar(ncid, vrVar, vr');
netcdf.putVar(ncid, vzVar, vz');
netcdf.putVar(ncid, btotVar, btot');
netcdf.putVar(ncid, btVar, bt');
netcdf.putVar(ncid, brVar, br');
netcdf.putVar(ncid, bzVar, bz');
netcdf.putVar(ncid, gradRteVar, gradRte');
netcdf.putVar(ncid, gradZteVar, gradZte');
netcdf.putVar(ncid, gradRtiVar, gradRti');
netcdf.putVar(ncid, gradZtiVar, gradZti');
netcdf.putVar(ncid, gradYtiVar, 0*gradZti');
netcdf.putVar(ncid, gradYteVar, 0*gradZte');
netcdf.putVar(ncid, gradTVar, gradT');

netcdf.close(ncid);

