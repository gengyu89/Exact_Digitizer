function cbar_regrid = interp_cbar(cbar_raw, cbar_lim, N_levels)
%INTERP_CBAR Subroutine for interpolating
%   a color bar with much denser values.
% 


% Among those methods provided by interpn(),
%   only 'spline' and 'makima' support extrapolation;
%   however, 'makima' causes smaller wiggles, apparently.
% 
% Read this analysis https://blogs.mathworks.com/cleve/2019/04/29/
%   makima-piecewise-cubic-interpolation/
% 

% split data into vectors
cbar_val = cbar_raw(:,1);
cbar_red = cbar_raw(:,2);
cbar_gre = cbar_raw(:,3);
cbar_blu = cbar_raw(:,4);

% specify interpolation method
method = 'makima';

% when slight extrapolation for the color scale
% is needed, 'spline' may create wierd colors

% interpolate as column vectors
cval_regrid = linspace(cbar_lim(1), cbar_lim(2), N_levels)';
cred_regrid = interpn(cbar_val, cbar_red, cval_regrid, method);
cgre_regrid = interpn(cbar_val, cbar_gre, cval_regrid, method);
cblu_regrid = interpn(cbar_val, cbar_blu, cval_regrid, method);

% assemble the RGB matrix
crgb_regrid = [cred_regrid, cgre_regrid, cblu_regrid];
crgb_regrid(crgb_regrid < 0.0) = 0.0;  % fix any invalid values
crgb_regrid(crgb_regrid > 255) = 255;

% assemble the whole matrix
cbar_regrid = [cval_regrid, crgb_regrid];


end

