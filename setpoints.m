function r = setpoints(Nr,N)

if Nr==3

    r1 = [0 0 2*ones(1,N-2)];
    r2 = [0 0 -1*ones(1,N-2)]; 
    r3 = [0 0 -2*ones(1,N-2)]; 
    r=[r1; r2; r3];
   
end
   
if Nr==1

    r = [0 0 2*ones(1,N-2)];
   
end