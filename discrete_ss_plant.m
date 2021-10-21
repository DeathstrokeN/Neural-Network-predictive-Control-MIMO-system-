function Gd = discrete_ss_plant(Nu,Ny)

if Nu==3 & Ny==3

    Tech=2;
    s=tf('s');
    G11=2/(1+10*s);
    G12=1/(1+7*s)^2;
    G13=-1/(1+5*s)^2;
    G21=-1*(1+15*s)/(1+10*s)^2;
    G22=2*(1-10*s)/(1+10*s)^2;
    G23=1*(1-2*s)/(1+10*s)^2;
    G31=-1*(1-15*s)/(1+5*s)^2;
    G32=-2*(1-10*s)/(1+10*s)^2;
    G33=-2*(1+2*s)/(1+10*s)^2;
    Gd=ss(c2d([G11 G12 G13; G21 G22 G33; G31 G32 G33],Tech,'z'));
   
end


if Nu==1 & Ny==1

    Tech=2;
    s=tf('s');
    G11=2/(1+10*s);
     Gd=ss(c2d(G11,Tech,'z'));
   
end