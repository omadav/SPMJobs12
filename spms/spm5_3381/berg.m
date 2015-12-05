function [mu_berg,lam_berg,f] = berg(R,sigma,nmax,J,mu_berg_init,lam_berg_init)
%BERG - PARAMETER CALCULATION FOR EEG MULTILAYER SPHERICAL FORWARD MODEL (berg.m)
% function [mu_berg,lam_berg,f] = berg(R,sigma,nmax,J,mu_berg_init,lam_berg_init)
%      -or- [mu_berg,lam_berg] = berg(R,sigma,nmax,J)
%      -or- [mu_berg,lam_berg] = berg(R,sigma,nmax)
%      -or- [mu_berg,lam_berg] = berg(R,sigma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function computes the Berg Eccentricity and Magnitude parameters associated with 
% a series Approximiation of a Single Dipole in a Multilayer Sphere -by-
% multiple dipoles in a single shell. Zhang: Eq (1i,2i,1i',5i'' and 7i).
%
% This function has been generalized to compute Berg parameters for an approximation
% based on a total of J (user-specified) dipoles (J=3 is recommended)
%
% (Ref: Z. Zhang "A fast method to compute surface potentials generated by dipoles 
% within multilayer anisotropic spheres" (Phys. Med. Biol. 40, pp335-349,1995)   
% 
% INPUTS (Required):
%         R    : Radii(in meters) of sphere from 
%                INNERMOST to OUTERMOST                                     NL x 1
%         sigma: conductivity from INNERMOST to OUTERMOST                   NL x 1
%
% INPUTS (Optional):
%         nmax : # of terms used in Legendre Expansion used to  
%               "fit" Berg Parameters (Default: 100)                        scalar
%           J  : Number of Berg Dipoles (Default: 3)                        scalar
%  mu_berg_init: User specified initial value for Berg eccentricity
%                factors (default values shown below used otherwise)        J x 1
% lam_berg_init: User specified initial value for Berg magnitude
%                factors (default values shown below used otherwise)        J x 1
%  
%                where: NL = # of sphere layers; J = # of Berg Dipoles
%
% OUTPUTS:
%        mu_berg: Computed Value of Berg eccentricity factors                J x 1
%       lam_berg: Computed Value of Berg magnitude factors                   J x 1
%              f: Legendre Expansion Weights used to fit Berg Parameters     nmax x 1
%
% External Functions and Files:
%    zhang_fit.m: External Function used to fit Berg Parameters (Zhang Eq# 5i")
%    
% By John Ermer 5/5/99 
%    6/21/99: Addded Legendre Expansion weights as optional output (JE)
%    9/30/99: Fixed Logic to pass Initial Berg Parameters (JE)
%    Nov 2001: SB - replaced fmins syntax (obsolete in Matlab R12) by fminsearch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%<autobegin> ---------------------- 27-Jun-2005 10:29:44 -----------------------
% --------- Automatically Generated Comments Block Using AUTO_COMMENTS ---------
%
% CATEGORY: Forward Modeling
%
% Alphabetical list of external functions (non-Matlab):
%   toolbox\berg.m  NOTE: Routine calls itself explicitly
%
% At Check-in: $Author: Mosher $  $Revision: 18 $  $Date: 6/27/05 8:59a $
%
% This software is part of BrainStorm Toolbox Version 27-June-2005  
% 
% Principal Investigators and Developers:
% ** Richard M. Leahy, PhD, Signal & Image Processing Institute,
%    University of Southern California, Los Angeles, CA
% ** John C. Mosher, PhD, Biophysics Group,
%    Los Alamos National Laboratory, Los Alamos, NM
% ** Sylvain Baillet, PhD, Cognitive Neuroscience & Brain Imaging Laboratory,
%    CNRS, Hopital de la Salpetriere, Paris, France
% 
% See BrainStorm website at http://neuroimage.usc.edu for further information.
% 
% Copyright (c) 2005 BrainStorm by the University of Southern California
% This software distributed  under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPL
% license can be found at http://www.gnu.org/copyleft/gpl.html .
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%<autoend> ------------------------ 27-Jun-2005 10:29:44 -----------------------


%%% THIS PART CHECKS INPUT PARAMETERS FOR THEIR DIMENSION AND VALIDITY %%%
%
NL = length(R);                          % # of concentric sphere layer
% 
%%% THIS PART CHECKS FOR THE PRESENCE OF OPTIONAL PARAMETERS AND ASSIGNS %%%
%%% DEFAULT VALUES IF NECESSARY %%%
%
if nargin < 3    % Check # terms to see if number of Legendre expansion terms is specified
    nmax = 200;  % Default # of Legendre Terms                
end
%
if nargin < 4  % Check # of Berg Paramters to be generated
    J=3;       % Default # of Berg Parameters                
end
%
if (nargin < 5)   % Check if user specified initial value for Berg Paramters
    mu_berg_init = (1/(J+2))*[1:1:J];  % Default Value for Initial Eccentricity Parameters 
   lam_berg_init = 0.2*ones(1,J);      % Default Value for Initial Magnitude Parameters
else
   if length(mu_berg_init)~=length(lam_berg_init)
      error('Initial Berg Eccen and Mag parameters are of Different Lengths!!!')
   elseif length(mu_berg_init) ~= J
      error('Initial Berg Param Size does not match number of dipoles specified!!!')
   end 
end
%
%%% THIS PART COMPUTES THE WEIGHTS fn ASSOCIATED WITH A LEGENDRE EXPANSION %%%%%%%%%%%%%%%
%%% THE WEIGHTS fn DEPEND ONLY ON THE MULTISPHERE RADII AND CONDUCTIVITY %%%%%%%%%%%%%%%%%
%%% (This portion for computing fn derived from gainp_sph.m by CCH,  Aug/20/1995)
%
Re_mag = R(NL);         % Radius of outermost layer (Sensor distance from origin)
if NL==1
   f=ones(1,nmax);
else
%
for k = 1:NL-1 
   s(k) = sigma(k)/sigma(k+1);
end
a = Re_mag./R;
ainv = R/Re_mag;
sm1 = s-1;
twonp1 = 2*[1:nmax]+1;
twonp1 = twonp1(:);
f = zeros(nmax,1);
%
for n = 1:nmax
 np1 = n+1;
 Mc = eye(2);
 for k = 2:NL-1
    Mc = Mc*[n+np1*s(k),  np1*sm1(k)*a(k)^twonp1(n);...
             n*sm1(k)*ainv(k)^twonp1(n) , np1+n*s(k)];
 end
Mc(2,:) = [n*sm1(1)*ainv(1)^twonp1(n) , np1+n*s(1)]*Mc; % Compute only components of interest
Mc = Mc/(twonp1(n))^(NL-1);
f(n) = n/(n*Mc(2,2)+np1*Mc(2,1));
end
end
%
%%%% End of Calculation of weights fn %%%%%%%
%
%%%% THIS PART COMPUTES THE BERG PARAMETERS ASSOCIATED WITH THE SPHERE RADII AND %%%%%%%%%%%%% 
%%%% AND CONDUCTIVITY BY MINIMIZING THE FUNCTION 5I" SPECIFIED IN ZHANG %%%%%%%%%%%%%%%%%%%%%%
%
% OPTIONS=zeros(1,18);                 % Reset all options flags
% OPTIONS(1:3) = [0 1.e-9 1.e-9];      % Set options termination search criteria
% OPTIONS(14) = J*1000;                  % Set max number of steps
if spm_matlab_version_chk('6.5.1') < 0
OPTIONS = optimset('MaxFunEvals',J*1000,'MaxIter',J*1000,'TolFun',[0 1.e-9 1.e-9]); 
else
   OPTIONS = optimset('MaxFunEvals',J*1000,'MaxIter',J*1000,'TolFun',[1.e-9]); 
end
[berg_out,fval,outputs]= fminsearch('zhang_fit',[mu_berg_init lam_berg_init(2:J)],OPTIONS,R,f); 

%num_steps = outputs.iterations;
mu_berg = berg_out(1:J);
lam_berg(2:J) = berg_out(J+1:2*J-1);
lam_berg(1) = f(1) - sum(lam_berg(2:J));

f = f';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
