function [points, Ix, Iy] = kp_harris(im)
    % Extract keypoints using Harris algorithm (with an improvement
    % version)
    %
    % Author :: Vincent Garcia
    % Date   :: 05/12/2007
    %
    % INPUT
    % =====
    % im     : the graylevel image
    %
    % OUTPUT
    % ======
    % points : the interest points extracted
    %
    % REFERENCES
    % ==========
    % C.G. Harris and M.J. Stephens. "A combined corner and edge detector",
    % Proceedings Fourth Alvey Vision Conference, Manchester.
    % pp 147-151, 1988.
    %
    % Alison Noble, "Descriptions of Image Surfaces", PhD thesis, Department
    % of Engineering Science, Oxford University 1989, p45.
    %
    % C. Schmid, R. Mohrand and C. Bauckhage, "Evaluation of Interest Point Detectors",
    % Int. Journal of Computer Vision, 37(2), 151-172, 2000.
    %
    % EXAMPLE
    % =======
    % points = kp_harris(im)

    % only luminance value
    im = double(im(:,:,1));
    sigma = 1.5;

    % derivative masks
    s_D = 0.7*sigma;
    x  = -round(3*s_D):round(3*s_D);
    dx = x .* exp(-x.*x/(2*s_D*s_D)) ./ (s_D*s_D*s_D*sqrt(2*pi));
    dy = dx';

    % image derivatives
    Ix = conv2(im, dx, 'same');
    Iy = conv2(im, dy, 'same');

    % sum of the Auto-correlation matrix
    s_I = sigma;
    g = fspecial('gaussian',max(1,fix(6*s_I+1)), s_I);
    Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');

    % interest point response
%    cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);				% Alison Noble measure.
     %k=0.31;
     %k=0.26;
     %k=0.21;
     %k=0.16;
     %k=0.11; 
     k=0.06;
     %k=0.01;
     %k=0.001; 
     cim = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;	% Original Harris measure.

    % find local maxima on 3x3 neighborhood
    [r,c,max_local] = findLocalMaximum(cim,3*s_I);

    % set threshold 1% of the maximum value
%    t = 0.01*max(max_local(:));
    t = 0.1*max(max_local(:));

    % find local maxima greater than threshold
    [r,c] = find(max_local>=t);

    % build interest points
    points = [r,c];
