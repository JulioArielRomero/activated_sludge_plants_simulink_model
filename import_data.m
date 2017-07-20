
dat_dry=importdata('datos/Inf_dry_2006.txt','\t',1);
dat_rain=importdata('datos/Inf_rain_2006.txt','\t',1);
dat_strm=importdata('datos/Inf_strm_2006.txt','\t',1);


%Append data
aaa=dat_dry.data;
aaa_=dat_strm.data;
aaa_(:,1)=aaa_(:,1)+aaa(end,1);
Qi=[aaa;aaa_];

figure, plot(Qi(:,1),Qi(:,15))
ylabel('flow rate [m^3d^{-1}]')
xlabel('time [days]')
figure, plot(Qi(:,1),Qi(:,[3 11 12]))
xlabel('time [days]')
ylabel('concentration [gm^3]')
legend('Ss','Snh','Snd')
figure, plot(Qi(:,1),Qi(:,[4 5 6 13]))
xlabel('time [days]')
ylabel('concentration [gm^3]')
legend('Xi','Xs','Xbh','Xnd')



%scale data (if needed)
for i=1:size(Qi,1)
Qi(i,2:end)=Qi(i,2:end).*[1 1 1 1 1 1 1 1 1 1.5 1 1 1 0.15];
end




%Initial conditions (from [1])
%[1] J. Alex et.al. Benchmark Simulation Model no. 1 (BSM1). Dept. of Industrial Electrical Engineering and Automation
%Lund University. 2008. http://www.benchmarkWWTP.org/ 
Si0  =30; %Soluble inert organic matter
Ss0  =69.5; %Readily biodegradable substrate
Xi0  =51.2; %Particulate inert organic matter
Xs0  =202.32; %Slowly biodegradable substrate
Xbh0 =28.17; %Active heterotrophic biomass
Xba0 =25; %Active autotrophic biomass
Xp0  =0; %Particulate products arising from biomass decay
So0  =0; %Oxygen
Sno0 =0; %Nitrate and nitrite nitrogen
Snh0 =5; %NH 4+ + NH 3 nitrogen
Snd0 =6.95; %Soluble biodegradable organic nitrogen
Xnd0 =5; %Particulate biodegradable organic nitrogen
Salk0 =7; %Alkalinity





