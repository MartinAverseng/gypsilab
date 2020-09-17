%% alternateColumns
A = magic(3); B = magic(3)';
C = alternateColumns(A,B); assert(isequal(C,[8 8 1 3 6 4; 3 1 5 5 7 9; 4 6 9 7 2 2]));

%% alternateLines
A = magic(3); B = magic(3)';
C = alternateLines(A,B); assert(isequal(C,[8 1 6; 8 3 4; 3 5 7; 1 5 9; 4 9 2; 6 7 2]));

%% Gauss_Legendre1D
[x,w] = Gauss_Legendre1D(20,-1,5);
f = @(x)(1./(1 + x.^2)); 
int_approx = sum(f(x).*w); 
int_exact = atan(5) + atan(1); 
assert(abs(int_exact - int_approx)<1e-6);

%% invPerm
A = magic(3); A = A(:); 
[B,I] = sort(A); p = invPerm(I); assert(norm(B(p) - A,'inf')==0);

%% newtonraphson
a = 5; f = @(x)(x.^2 - a); df = @(x)(2*x); x0 = 20;
x = newtonraphson(f,x0,df,'maxit',30,'tol',1e-8);
assert(abs(x - sqrt(5))<1e-8);

%% repeatColumns
A = magic(5); Q= 10; B = repeatColumns(A,Q); 
for i = 1:Q
    assert(isequal(A,B(:,i:Q:end)));
end

%% repeatLines
A = magic(5); Q= 10; B = repeatLines(A,Q); 
for i = 1:Q
    assert(isequal(A,B(i:Q:end,:)));
end

%% safeDx
f = @(x)(log(1+x).*log(1 - x)); I = [-1,1]; dx = 1e-10;
x = linspace(-1,1,1000); x = x(2:end-1);
df_approx = safeDx(f,I,dx); 
df_exact = @(x)(log(1-x)./(1+x) - log(1+x)./(1-x));
assert(norm(df_exact(x) - df_approx(x),'inf')<1e-3);

%% Composite integrals
f = @(x)(1./(1 + 25*x.^2)); % Runge function;
r = compositeIntegral(f,-6,6,'N',30,'gss',7);
err = abs(r - 2/5*atan(30));
assert(err < 1e-3); 