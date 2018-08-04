% 이미지 좌표 계산해서 저장
% 2013. 04. 04 
% 전의익
% 19.09.2016 modified by Hwiyoung Kim

function xy_ics = image_coordinate(dem, R, xyz_eo, focal_length, pixel_size, pixel_cnt)
% Purpose: Back-projecting rectified ground coordinates
% Output - 19.09.2016
%   xy_ics: photo coordinates in Images Coordinates System (3x1)
% Input
%   dem: position each pixel of the plane (cell, row x column x 3)
%   R: rotation matrix (3x3)
%   xyz_eo: postition of camera in Ground Coordinate System (1x3)
%   focal_length: focal length [m]
%   pixel_size: pixel size [m/px]
%   pixel_cnt: the number of pixel - [row, column]

    row = size(dem, 1); col = size(dem,2);
    xy_ics = cell(row, col);
    for i=1:row             % y direction, row
        for j=1:col         % x direction, column
            xyz_ground=[dem{i,j}(1) dem{i,j}(2) dem{i,j}(3)];

            p_c = R * (xyz_ground-xyz_eo)';             % projection
            scale = -p_c(3) / focal_length;
            xy_image = (1 / scale) * p_c / pixel_size;  % 1 - x, 2 - y, unit: px

            xy_ics{i,j}(1) = xy_image(1) + pixel_cnt(2)/2;       % x direction, column
            xy_ics{i,j}(2) = -xy_image(2) + pixel_cnt(1)/2;       % y direction, row
        end
    end
end


