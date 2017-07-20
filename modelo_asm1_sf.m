function [sys,x0,str,ts] = modelo_asm1_sf(t,x,u,flag,ci,param)
%asm1 model


switch flag
    case 0
        [sys,x0,str,ts]=mdlInitializeSizes(ci);
    case 1
        sys=mdlDerivatives(t,x,u,param);
    case 3
        sys=mdlOutputs(t,x,u);
        
        %%%%%%%%%%%%%%%%%%%
        % Unhandled flags %
        %%%%%%%%%%%%%%%%%%%
    case { 2, 4, 9 },
        sys = [];
        
        %%%%%%%%%%%%%%%%%%%%
        % Unexpected flags %
        %%%%%%%%%%%%%%%%%%%%
    otherwise
        error(['Unhandled flag = ',num2str(flag)]);
        
end

function [sys,x0,str,ts]=mdlInitializeSizes(ci)


sizes = simsizes;
sizes.NumContStates  = 13;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 14;
sizes.NumInputs      = 15;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = ci;
str = [];
ts  = [0 0];






% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u,param)


%Parameters
% Stoichiometric
Yh=param(1);
Ya=param(2);
ixb=param(3);
fp=param(4);
ixp=param(5);
% Kinetic parameters
muh=param(6);
Ks=param(7);
Koh=param(8);
Kno=param(9);
ng=param(10);
mua=param(11);
Knh=param(12);
Koa=param(13);
bh=param(14);
ba=param(15);
ka=param(16);
kh=param(17);
Kx=param(18);
nh=param(19);
%O2 transference
So_sat=param(20);
Vol=param(21);

%state vector
Si  =x(1); %Soluble inert organic matter
Ss  =x(2); %Readily biodegradable substrate
Xi  =x(3); %Particulate inert organic matter
Xs  =x(4); %Slowly biodegradable substrate
Xbh =x(5); %Active heterotrophic biomass
Xba =x(6); %Active autotrophic biomass
Xp  =x(7); %Particulate products arising from biomass decay
So  =x(8); %Oxygen
Sno =x(9); %Nitrate and nitrite nitrogen
Snh =x(10); %NH 4+ + NH 3 nitrogen
Snd =x(11); %Soluble biodegradable organic nitrogen
Xnd =x(12); %Particulate biodegradable organic nitrogen
Salk =x(13); %Alkalinity


%Inlet flowrate
Qi=u(14);
%Concentrations vector in the inlet flow
Zi=u(1:13);



%Oxygen transfer coefficient
KLa=u(15);


%Stoichiometric matrix
K=[ 0 -1/Yh  0  0          1   0      0   -(1-Yh)/Yh       0                     -ixb          0     0                -ixb/14 ;...
    0 -1/Yh  0  0          1   0      0   0                -(1-Yh)/(2.86*Yh)     -ixb          0     0                (1-Yh)/(14*2.86*Yh)-ixb/14 ;...
    0  0     0  0          0   1      0   -(4.56-Ya)/Ya    1/Ya                  -(ixb+1/Ya)   0     0                -ixb/14-1/(7*Ya) ;...
    0  0     0  (1-fp)    -1   0     fp   0                0                     0             0     (ixb-fp*ixp)     0 ;...
    0  0     0  (1-fp)     0  -1     fp   0                0                     0             0     (ixb-fp*ixp)     0 ;...
    0  0     0  0          0   0      0   0                0                     1            -1     0                1/14 ;...
    0  1     0  -1         0   0      0   0                0                     0             0     0                0;...
    0  0     0  0          0   0      0   0                0                     0             1    -1                0];





%Reaction rates vector
theta=[muh*(Ss/(Ks+Ss))*(So/(Koh+So))*Xbh;...
    muh*(Ss/(Ks+Ss))*(Koh/(Koh+So))*(Sno/(Kno+Sno))*ng*Xbh;...
    mua*(Snh/(Knh+Snh))*(So/(Koa+So))*Xba;...
    bh*Xbh;...
    ba*Xba;...
    ka*Snd*Xbh;...
    kh*Xs/Xbh/(Kx+Xs/Xbh)*((So/(Koh+So))+nh*Koh/(Koh+So)*Sno/(Kno+Sno))*Xbh;...
    kh*Xs/Xbh/(Kx+Xs/Xbh)*((So/(Koh+So))+nh*Koh/(Koh+So)*Sno/(Kno+Sno))*Xbh*Xnd/Xs];

Qo=Qi;

sys= K'*theta + 1/Vol*(Qi*Zi - Qo*x);

% Effect of aireation on the Oxygen concentration
sys(8)=sys(8) + KLa*(So_sat - So);



sys=sys';
% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

%Inlet flowrate
Qi=u(14);



sys=[x;Qi];
%sys = C*x;

% end mdlOutputs