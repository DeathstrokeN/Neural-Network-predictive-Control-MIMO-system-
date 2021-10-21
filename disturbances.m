function d = disturbances(Nd,N)

if Nd==3

    d1=[zeros(1,N/2) ones(1,N/2)]; 
    d2=[zeros(1,N/2) ones(1,N/2)]; 
    d3=[zeros(1,N/2) ones(1,N/2)]; 
    d=[d1; d2; d3];
   
end

if Nd==1

    d=[zeros(1,N/2) ones(1,N/2)]; 
   
end
   