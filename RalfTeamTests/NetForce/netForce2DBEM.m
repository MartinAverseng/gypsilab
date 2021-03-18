close all;
clear all;

%% Geometry
% Create a non radially symetric mesh mesh whose boundary has two connected components:
N = 50; rad1 = 1; rad2 = 2;
m_Space = mshAssymetricRing(N,rad1,rad2);
m_Gamma = union(mshSphere(100,1),translatation([2,2,2],mshSphere(100,1))); 
m_Gamma = m_Space.bnd;
c = m_Gamma.ctr;
indGamma1 = c(:,1).^2 + c(:,2).^2 > (rad1 + rad2)^2/4;
indGamma2 = ~indGamma1;
m_Gamma1 = m_Gamma.sub(indGamma1);
m_Gamma2 = m_Gamma.sub(indGamma2);

% Domains of integration
gss = 3; % Number of Gauss points
Gamma = dom(m_Gamma,gssm_Gamma = m_Space.bnd;);
Gamma2 = dom(m_Gamma2,gss);

Gxy = @(X,Y)femGreenKernel(X,Y,'[log(r)]',0); % 0 wave number
S1_Gamma = fem(m_Gamma,'P1');
S1_Gamma2 = fem(m_Gamma2,'P1');

% Single layer potential
V = -1/(2*pi)*integral(Gamma,Gamma,S1_Gamma,Gxy,S1_Gamma);
V = V + -1/(2*pi)*regularize(Gamma,Gamma,S1_Gamma,'[log(r)]',S1_Gamma);

B = integral(Gamma,S1_Gamma);
sys = [V B;B' 0];

% right hand side:
P = restriction(S1_Gamma,m_Gamma2);
F = integral(Gamma,S1_Gamma,S1_Gamma)*(P'*ones(size(P,1),1));
rhs = [F;0];
sol = sys\rhs;
lambda = sol(1:end-1);
mu = sol(end);
dnu = P*lambda;
figure;
surf(S1_Gamma2,dnu);
axis equal;

SL = (-1/(2*pi))*integral(m_Gamma1.vtx,Gamma,Gxy,S1_Gamma);
% Array of int_{Gamma}G(x - y)phi_h(y) for x = x1 ... xN
SL = SL + (-1/(2*pi))*regularize(m_Gamma1.vtx,Gamma,'[log(r)]',S1_Gamma);

u = SL*lambda+mu;


I = integral(Gamma2,S1_Gamma2,ntimes(S1_Gamma2));
F = 1/2*dnu'*I{1}*dnu;