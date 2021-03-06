% Compare assembling time for FEM operators

%% P1

clean;
N = 1e4;

m = mshSquare(N,[1 1]);
Gamma = dom(m,3);


Wh = fem(m,'P1');
disp('old fem P1');
tic;
M2 = integral(Gamma,Wh,Wh);
K2 = integral(Gamma,grad(Wh),grad(Wh));
toc;

Gamma = dom(m,3);

Vh = P1(m);
disp('New Fe P1');
tic;
M1 = integral(Gamma,Vh,Vh);
K1 = integral(Gamma,grad(Vh),grad(Vh));
toc;


%% P2

m = mshSphere(1e4,1);
Gamma = dom(m,7);
Vh = P2(m);
disp('New Fe P2');
tic;
M1 = integral(Gamma,Vh,Vh);
K1 = integral(Gamma,grad(Vh),grad(Vh));
toc;

disp('Old Fe P2');
Wh = fem(m,'P2');
tic;
M2 = integral(Gamma,Wh,Wh);
K2 = integral(Gamma,grad(Wh),grad(Wh));
toc;
