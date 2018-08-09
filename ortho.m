% Rectifying close-range images
% 30.11.2016
% Hwiyoung Kim

clc
clearvars
close all
%% input value
% TG-L800s
pixel_size = 1.25e-6;
focal_length = 3.85e-3;

% % iPhone 7
% pixel_size = 0.00122331e-3; % m
% focal_length = 3.99e-3;     % m

gsd = 0.01;

%% Define the Target Surface

% IMG_20160831_140354.jpg
p{1} = [151437.7152 360611.558 54.59053]';    % GP10
p{2} = [151445.371 360618.074 54.45871]';     % GP07
p{3} = [151437.9584 360611.3105 56.561396]';  % point 1

% Define the normal vector of the plane
v1 = p{2} - p{1};           % x-axis
v2 = p{3} - p{1};
nv = cross(v1, v2);         % normal vector: z-axis
d = dot(nv, p{1});

% Define a basis of the plane
y_basis = cross(nv, v1);         % y-axis
new_basis = [v1 y_basis nv];     % Basis of Plane

% % Visualize the basis vector
% CoP = p{1};     % Center of Plane
% RoP = [v1/norm(v1) y_basis/norm(y_basis) nv/norm(nv)];
% hold on;
% vis_coord_system(CoP, RoP, 5, '', 'r');
% grid on, axis equal;
% xlabel('X'), ylabel('Y'), zlabel('Z');

%% Creating orthophoto

EO_all = [151448.381224	360608.187181 51.007198 120.547791 36.035759 -21.870075];    % IMG_20160831_140354.jpg

for i=3:3
    img = imread('IMG_20160831_140354.jpg');
    pixel_cnt = size(img);     % [row column]
    EO=EO_all(i-2,1:6);
    
    % Rotation Matrix
    ori = pi / 180 * [EO(4) EO(5) EO(6)];
    R = Rot3D(ori);

    %% Computing ground boundary of projected image in GCS
    % and new coordinate system of target surface
    [g_c, u, proj_coord, new_proj_coord] = vertex_g(pixel_cnt, pixel_size, focal_length, EO, R, new_basis, d, p);
    
    %% 가상의 DEM 생성
    col_s = (g_c(2)-g_c(1))/gsd
    row_s = (g_c(4)-g_c(3))/gsd

    %% dem생성 및 dem의 row, column 계산
    dem = dem_m(g_c, ceil(row_s), ceil(col_s), gsd, g_c(6));
    converted_dem = convert_dem(u, dem);
    
    %% 이미지 좌표 계산, 화소값 가져오기 // 상대좌표
    xyz_eo = [EO(1) EO(2) EO(3)];
    xy_ics = image_coordinate(converted_dem, R, xyz_eo, focal_length, pixel_size, pixel_cnt);
    
    FR = pixel_color(pixel_cnt, xy_ics, img, 1);
    FG = pixel_color(pixel_cnt, xy_ics, img, 2);
    FB = pixel_color(pixel_cnt, xy_ics, img, 3);

    %% 각 화소값들 모아서 출력 및 저장
    rgb_image = cat(3, FR, FG, FB);

    figure;
    imshow(rgb_image);
    imwrite(rgb_image, 'rectified.png'); 
 
end