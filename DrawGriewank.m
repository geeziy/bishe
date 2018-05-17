function DrawGriewank()
x1=linspace(-5,5,400);
x2=x1;
[X1,X2]=meshgrid(x1,x2);
A=X1.^2+X2.^2;
B=cos(X1).*cos(X2/sqrt(2));
Z=(1/4000)*A-B+1;
meshc(X1,X2,Z)
xlabel('X1')
ylabel('X2')
zlabel('Z')
title('Griewank Function')
axis square
