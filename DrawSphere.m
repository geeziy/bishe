function DrawSphere()
x1=linspace(-5,5,400);
x2=linspace(-5,5,400);
[X1,X2]=meshgrid(x1,x2);
Z=X1.^2+X2.^2;
meshc(X1,X2,Z)
xlabel('X1')
ylabel('X2')
zlabel('Z')
title('Sphere Function')

