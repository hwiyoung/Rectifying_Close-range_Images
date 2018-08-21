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

    %% Visualize the boundary in original coordinates system
    % Coordinates of image vertices in Camera Coordinate System
    image_xy{1} = [pixel_cnt(2)*pixel_size/2, pixel_cnt(1)*pixel_size/2, -focal_length]';    % TR
    image_xy{2} = [pixel_cnt(2)*pixel_size/2, -pixel_cnt(1)*pixel_size/2, -focal_length]';   % BR
    image_xy{3} = [-pixel_cnt(2)*pixel_size/2, -pixel_cnt(1)*pixel_size/2, -focal_length]';  % BL
    image_xy{4} = [-pixel_cnt(2)*pixel_size/2, pixel_cnt(1)*pixel_size/2, -focal_length]';   % TL
    
    % Computing ground coordinates corresponding to image vertices
    proj_coord = cell(4,1);
    for i=1:4
        proj_coord{i} = xy_g_min(EO, R, image_xy{i}, u(:,3), d);
        scatter3(proj_coord{i}(1), proj_coord{i}(2), proj_coord{i}(3), 200, 'filled', 'MarkerFaceColor', 'b');
        text(proj_coord{i}(1), proj_coord{i}(2), proj_coord{i}(3), sprintf('%d', i), 'FontSize', 10);
        hold on;
    end
    
    % visualize the vertex boundary
    vertex_proj = cell2mat(proj_coord')';
    face = [1 2 3 4];
    patch('Faces', face, 'Vertices', vertex_proj, 'FaceAlpha', 0, 'EdgeColor', [0 0 1], 'LineWidth', 2);
    
    ux = u(:,1) / norm(u(:,1));       % normalized virtual axis1 - ux
    uz = u(:,3) / norm(u(:,3));
    uy = cross(uz, ux);               % normalized virtual axis2 - uy
    u_norm = [ux uy uz];
    
    % Visualize the basis vector
    hold on;
    grid on, axis equal;
    xlabel('X'), ylabel('Y'), zlabel('Z');
    title('Original Coordinate System');
    
    plot3([PoP{1}(1) PoP{2}(1)], [PoP{1}(2) PoP{2}(2)], [PoP{1}(3) PoP{2}(3)]);
    plot3([PoP{1}(1) PoP{3}(1)], [PoP{1}(2) PoP{3}(2)], [PoP{1}(3) PoP{3}(3)]);
    
    %% Visualize the boundary in changed coordinates system
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
    
    % converting to new(virtual) coordinate systems
    new_PoP = cell(3,1);
    for i=1:3
        new_PoP{i} = u_norm' * PoP{i};  % originally, inv(u)*proj_coord{i}
    end
    
    % visualize the boundary
    figure;
    vertex_gc = cell2mat(p')';
    patch('Faces', face,'Vertices', vertex_gc, 'FaceAlpha', 0, 'EdgeColor', [0 0 1], 'LineWidth', 5);
    
    % visualize the basis vector
    CoP = new_PoP{1};                 % Center of Plane
    RoP = eye(3);
    hold on;
    vis_coord_system(CoP, RoP, 5, '', 'r');
        
    hold on;
    vertex_gc_boundary = [max(edge_x) max(edge_y) max(edge_z); max(edge_x) min(edge_y) max(edge_z); ...
        min(edge_x) min(edge_y) max(edge_z); min(edge_x) max(edge_y) max(edge_z)];
    patch('Faces', face,'Vertices', vertex_gc_boundary, 'FaceAlpha', 0, 'EdgeColor', [0 1 0.2], 'LineWidth', 5);
    axis equal;
    view(3), grid on;
    xlabel('X'), ylabel('Y'), zlabel('Z');
    title('Changed Coordinate System');
    
end