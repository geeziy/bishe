function DrawRosenbrock()
x1=linspace(-5,5,400);
x2=x1;
[X1,X2]=meshgrid(x1,x2);
Z=(X2.^2-X1).^2+(X2-1).^2;
meshc(X1,X2,Z)
xlabel('X1')
ylabel('X2')
zlabel('Z')
title('Rosenbrock Function')
