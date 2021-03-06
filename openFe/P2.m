classdef P2 < Fe

    
    methods
        function[this] = P2(m)
            this.typ = 'P2';
            this.opr = '[psi]';
            this.msh = m;
            this.nb = 3*(this.dim - 1);
        end
        function[s]    = name(~)
            s = 'P2';
        end
        function[X,elt2dof] = dof(this)
            m = this.msh;
            switch this.dim
                case 2 % Edge mesh
                    nv = size(m.vtx,1);
                    X = [m.vtx;m.ctr];
                    elt2dof = [m.elt(:,1), nv + (1:length(m))',m.elt(:,2)];
                case 3 % Triangular mesh
                    % Copy of Gypsi's code.
                    [edge,elt2edg] = m.edg;
                    X             = [m.vtx ; edge.ctr]; 
                    elt2dof         = [m.elt , elt2edg + size(m.vtx,1)];
            end
        end
        function[out] = psi_b(this,b,X)
            switch this.dim
                case 2 % Edge mesh
                    x = X;
                    switch b
                        case 1
                            r = 1 + 2*x.^2 - 3*x;
                        case 2
                            r = -4*x.^2 + 4*x;
                        case 3
                            r = 2*x.^2 - x;
                    end
                case 3 % Triangular mesh
                    points = [0 0; 1 0; 0 1; .5 .5; 0 0.5; .5 0];
                    C1 = ones(6,1);
                    f2 = @(X)(X(:,1));
                    C2 = f2(points);
                    f3 = @(X)(X(:,2));
                    C3 = f3(points);
                    f4 = @(X)(X(:,1).^2);
                    C4 = f4(points);
                    f5 = @(X)(X(:,2).^2);
                    C5 = f5(points);
                    f6 = @(X)(X(:,1).*X(:,2));
                    C6 = f6(points);
                    M = [C1,C2,C3,C4,C5,C6];
                    coeffs = inv(M);
                    x = X(:,1); y = X(:,2);
                    c = coeffs(:,b);
                    r = c(1) + c(2)*x + c(3)*y + c(4)*x.^2 ...
                        + c(5)*y.^2 + c(6)*x.*y;
            end
            out{1} = r;
        end
        function[out] = gradPsi_b(this,b,X)
            switch this.dim
                case 2 % edge mesh
                    x = X;
                    switch b
                        case 1
                            r = 4*x - 3;
                        case 2
                            r = -8*x + 4;
                        case 3
                            r = 4*x - 1;
                    end
                    out{1} = r;
                case 3 % triangular mesh
                    points = [0 0; 1 0; 0 1; .5 .5; 0 0.5; .5 0];
                    C1 = ones(6,1);
                    f2 = @(X)(X(:,1));
                    C2 = f2(points);
                    f3 = @(X)(X(:,2));
                    C3 = f3(points);
                    f4 = @(X)(X(:,1).^2);
                    C4 = f4(points);
                    f5 = @(X)(X(:,2).^2);
                    C5 = f5(points);
                    f6 = @(X)(X(:,1).*X(:,2));
                    C6 = f6(points);
                    M = [C1,C2,C3,C4,C5,C6];
                    coeffs = inv(M);
                    x = X(:,1); y = X(:,2);
                    c = coeffs(:,b);
                    r = cell(1,2);
                    r{1} = c(2) + 2*c(4)*x + c(6)*y;
                    r{2} = c(3) + 2*c(5)*y + c(6)*x;
                    out = r;
            end
        end
    end
    
end