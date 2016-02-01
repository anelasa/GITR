Te = 20;
Ti = 20;
q=1.602e-19;
e0 = 8.85e-12;
me = 9.11e-31;
mi = 1.66e-27;
d=0.1; %height of the simulation box
see = 0;%secondary electron emission coefficient for the material surface

Dl =  1e-5;
gyr = 5e-3;
fd = 0.5;

z0=0;
y0=0;
x0 = 0;

dx = 1e-3;
dy = 1e-3;
dz = 1e-3;

Npgx = 100;
Npgy = 100;
Npgz = 100;

Npgx1 = Npgx+1;
Npgy1 = Npgy+1;
Npgz1 = Npgz+1;

xpos = linspace(x0,Npgx*dx,Npgx1);
ypos = linspace(y0,Npgy*dy,Npgy1);
zpos = linspace(z0,Npgz*dz,Npgz1);


pdens = zeros(Npgx1,Npgy1,Npgz1);
pT = zeros(Npgx1,Npgy1,Npgz1);
Esheath = zeros(Npgx1,Npgy1,Npgz1);

pdens(:,:,:) = 2e19;
pT(:,:,:) = 20;


grid = linspace(0,d,100);

phi = -Te/(2*q)*log(2*pi*me/mi*(1+Ti/Te)/(1-see)^2)*q;

for i=1:Npgx1
    for j=1:Npgz1
Esheath(i,1:Npgy1,j) = phi*(fd*exp(-ypos/(2*Dl))/(2*Dl) + (1-fd)*exp(-ypos/gyr)/gyr);
    end
end