%Polynomial Plot
g=linspace(1.920,2.080,160)

y1= g.^9-18*g.^8+144*g.^7-672*g.^6+2016*g.^5-4032*g.^4+5376*g.^3-4608*g.^2+2304*g-512; %RHS

figure(1)
plot(g,y1)

hold on

y2=(g-2).^9;  %LHS
plot(g,y2)

hold off
