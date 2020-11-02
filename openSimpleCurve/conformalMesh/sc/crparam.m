function [w,beta,cr,aff,Q,orig,qdat] = crparam(w,beta,cr0,options)
%CRPARAM Crossratio parameter problem.
%   [W,BETA,CR,AFF,Q,ORIG] = CRPARAM(W,BETA) solves the parameter
%   problem associated with the crossratio formulation for the polygon
%   given by W and BETA. The polygon is first subdivided, then a
%   Delaunay triangulation and associated quadrilateral graph are
%   found. The nonlinear system of equations is solved to find the
%   prevertex crossratios CR.
%       
%   The returned arguments are the subdivided polygon (W and BETA), the
%   crossratios (CR), the affine transformation data computed by
%   CRAFFINE (AFF), the quadrilateral data structure (Q), and the
%   original-vertex flag vector returned by CRSPLIT (ORIG).
%       
%   If the output arguments are just [CR,AFF,Q], the subdivision step is
%   skipped. This is likely to destory accuracy if the polygon has
%   elongations or pinches, unless subdivision has already occurred.
%       
%   CRPARAM(W,BETA,TOL) attempts to find the solution to within accuracy
%   TOL. (Also see SCPAROPT.)
%       
%   CRPARAM(W,BETA,CR0) uses CR0 as an initial guess in the nonlinear
%   solution for CR. Note that length(CR0) must be length(W)-3 after
%   subdivision, so this parameter is useful only when the sudivision
%   step has been preprocessed.
%       
%   CRPARAM(W,BETA,CR0,OPTIONS) uses a vector of control parameters as
%   described in SCPAROPT.
%       
%   See also CRSPLIT, SCPAROPT, CRAFFINE, CRFIXWC, CRMAP, CRINVMAP.
       
%   Copyright 1998--2001 by Toby Driscoll.
%   $Id: crparam.m 298 2009-09-15 14:36:37Z driscoll $


n = length(w);				
w = w(:);
beta = beta(:);

% Set up defaults for missing args
if nargin < 4
  options = [];
  if nargin < 3
    cr0 = [];
  end
end

% Check inputs
err = sccheck('cr',w,beta);
if err==1
  fprintf('Use SCFIX to make polygon obey requirements\n')
  error(' ')
end

% Parse options
[trace,tol,method] = parseopt(options);
if length(cr0)==1
  tol = cr0;
  cr0 = [];
end
nqpts = max(ceil(-log10(tol)),4);

% Split 
if nargout ~= 3 
  [w,orig] = crsplit(w);
  n = length(w);
  beta = scangle(w);
end

% Triangulate
[edge,triedge,edgetri] = crtriang(w);
[edge,triedge,edgetri] = crcdt(w,edge,triedge,edgetri);

% Quadrilateral graph
Q = crqgraph(w,edge,triedge,edgetri);
  
% Quadrature data
qdat = scqdata(beta,nqpts);

% Find the crossratios to be sought
target = crossrat(w,Q);
    
% Data needed by the nonlinear function
fdat = {n,beta,target,Q,qdat};
  
% Set up starting guess
if isempty(cr0)
  z0 = log(abs(target));
else
  z0 = log(abs(cr0));
end

% Solve
opt = zeros(16,1);
opt(1) = trace;
opt(2) = method;
opt(6) = 100*(n-3);
opt(8) = tol;
opt(9) = tol/10;
opt(11) = 12;			% max step size
opt(12) = nqpts;
try
  [z,termcode] = nesolvei('crpfun',z0,opt,fdat);
catch
  % Have to delete the "waitbar" figure if interrupted
  close(findobj(allchild(0),'flat','Tag','TMWWaitbar'));
  error(lasterr) 
end
if termcode~=1
  warning('Nonlinear equations solver did not terminate normally.')
end
  
% Results
cr = exp(z);

% Affine transformations
aff = craffine(w,beta,cr,Q,tol);

% Abbreviated output form
if nargout==3
  w = cr;
  beta = aff;
  cr = Q;
end
