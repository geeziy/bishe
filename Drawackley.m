function Drawackley()
x1=linspace(-5,5,400);
x2=x1;
[X1,X2]=meshgrid(x1,x2);
A=sqrt(X1.^2+0.5*X2.^2);
B=cos(2*pi*X1)+cos(2*pi*X2); 
Z=-20*exp(-0.2*A)-exp(0.5*B)+20+exp(1);
% subplot(2,1,1)
meshc(X1,X2,Z)
xlabel('X1')
ylabel('X2')
zlabel('Z')
title('Ackley Function')
% subplot(2,1,2) 
% [c,h]=contour(X1,X2,Z);
% clabel(c,h);

