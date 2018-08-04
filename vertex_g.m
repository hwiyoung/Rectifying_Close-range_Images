% 사진의 꼭지점으로 지상의 꼭지점 좌표 계산
% 2013. 04. 04 
% 전의익 
% 01.12.2016 modified by Hwiyoung Kim

function [g_c, u_norm, proj_coord, p] = vertex_g(pixel_cnt, pixel_size, focal_length, EO, R, u, d, PoP)
% Purpose: Computing ground boundary of projected image
%          and virtual coordinate system of target surface
% Output - 01.12.2016
%   g_c: ground converage of the image in Ground Coordinate System
%   u_norm: unit vector in Virtual Coordinate System
% Input
%   pixel_cnt: the number of pixel - [row, column]
%   pixel_size: pixel size [m/px]
%   focal_length: focal length [m]
%   EO: position/attitude parameter of a camera (1x6)
%   R: rotation matrix (3x3)
%   u: basis of target surface (3x1)
%   d: constant of target surface (1x1)

%   PoP : points of the plane

    % Coordinates of image vertices in Camera Coordinate System
    image_xy{1} = [pixel_cnt(2)*pixel_size/2, pixel_cnt(1)*pixel_size/2, -focal_length]';    % TR
    image_xy{2} = [pixel_cnt(2)*pixel_size/2, -pixel_cnt(1)*pixel_size/2, -focal_length]';   % BR
    image_xy{3} = [-pixel_cnt(2)*pixel_size/2, -pixel_cnt(1)*pixel_size/2, -focal_length]';  % BL
    image_xy{4} = [-pixel_cnt(2)*pixel_size/2, pixel_cnt(1)*pixel_size/2, -focal_length]';   % TL
    
    % Computing ground coordinates corresponding to image vertices
    proj_coord = cell(4,1);
    for i=1:4
        proj_coord{i} = xy_g_min(EO, R, image_xy{i}, u(:,3), d);
    end
    
    ux = u(:,1) / norm(u(:,1));       % normalized virtual axis1 - ux
    uz = u(:,3) / norm(u(:,3));
    uy = cross(uz, ux);               % normalized virtual axis2 - uy
    u_norm = [ux uy uz];
    
    % converting to new(virtual) coordinate systems
    p = cell(4,1);
    for i=1:4
        p{i} = u_norm' * proj_coord{i};  % originally, inv(u)*proj_coord{i}
    end

    edge_x=[p{1}(1) p{2}(1) p{3}(1) p{4}(1)];
    edge_y=[p{1}(2) p{2}(2) p{3}(2) p{4}(2)];
    edge_z=[p{1}(3) p{2}(3) p{3}(3) p{4}(3)];

    % ground coverage
    g_c=[min(edge_x), max(edge_x), min(edge_y), max(edge_y), min(edge_z), max(edge_z)];
end