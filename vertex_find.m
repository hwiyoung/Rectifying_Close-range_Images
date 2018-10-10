% 기하보정 영상에서 투영된 꼭지점에 해당하는 영상좌표 찾기
% 20. 07. 2017
% Hwiyoung Kim

function index = vertex_find(x, y, z, proj_coord)
% Purpose: Computing ground boundary of projected image
%          and virtual coordinate system of target surface
% Output
%   row: the row index of vertices (matrix)
%   column: the column index of vertices (matrix)
% Input
%   x: X coordinates of DEM (matrix)
%   y: Y coordinates of DEM (matrix)
%   z: Z coordinates of DEM (matrix)
%   proj_coord: projected coordinates of vertices (cell, 4x1, 3x1)

    NoP = size(proj_coord, 1);  % number of points
    for i = 1:NoP
        diff_x = x - proj_coord{i}(1);
        diff_y = y - proj_coord{i}(2);
        diff_z = z - proj_coord{i}(3);
        sum_diff = sqrt(diff_x.^2 + diff_y.^2 + diff_z.^2);
        [r, c] = find(sum_diff == min(min(sum_diff)));
        index(i,1) = r;
        index(i,2) = c;
    end
end