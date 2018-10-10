% Rectifying close-range images
% 30.11.2016
% Hwiyoung Kim

clc
clearvars
close all
%% input value
% pixel_cnt = [3024 4032];
pixel_size = 0.00122331e-3; % m
focal_length = 3.99e-3;     % m

%% Define the Target Surface
p{1} = [151437.157 360610.984 56.384]';             % 33
p{2} = [151444.818 360617.503 56.263]';             % 32
p{3} = [151437.448797 360610.644387 58.538265]';    % point 2

% Define the normal vector of the plane
v1 = p{2} - p{1};       % x-axis
v2 = p{3} - p{1};       % pseudo y-axis
nv = cross(v1, v2);     % normal vector: z-axis
d = dot(nv, p{1});

% Define a basis of the plane
y_basis = cross(nv, v1);         % real y-axis
new_basis = [v1 y_basis nv];     % Basis of Plane

% % Visualize the basis vector
% CoP = p{1};     % Center of Plane
% RoP = [v1/norm(v1) y_basis/norm(y_basis) nv/norm(nv)];
% hold on;
% vis_coord_system(CoP, RoP, 5, '', 'r');
% grid on, axis equal;
% xlabel('X'), ylabel('Y'), zlabel('Z');

%% Creating orthophoto
dirname=[pwd,'\Input\'];
imagelist=dir(dirname);
siz=size(imagelist, 1);

EO_all=load('Input\EO_smart_esti.txt');

for i = 3:siz
    img_path=[dirname, imagelist(i).name];
    img = imread(img_path);
    pixel_cnt = size(img);     % [row column]
    EO=EO_all(i-2,2:7);
    
    % Rotation Matrix
    ori = pi / 180 * [EO(4) EO(5) EO(6)];
    R = Rot3D(ori);

    %% Computing ground boundary of projected image in GCS  
    % and new coordinate system of target surface
    [g_c, u, proj_coord, new_proj_coord] = vertex_g(pixel_cnt, pixel_size, focal_length, EO, R, new_basis, d, p);
    
    %% 가상의 DEM 생성
    gsd = computeGSD(EO, R, nv, d, focal_length, pixel_size);   % m/pix
    gsd = gsd*2;
    col_s = (g_c(2)-g_c(1))/gsd
    row_s = (g_c(4)-g_c(3))/gsd

    %% dem생성 및 dem의 row, column 계산
    dem = dem_m(g_c, ceil(row_s), ceil(col_s), gsd, g_c(6));    
    converted_dem = convert_dem(u, dem);
    
    grid_c_dem = cell2mat(converted_dem);
    grid_c_dem_x = grid_c_dem(1:3:end,:);
    grid_c_dem_y = grid_c_dem(2:3:end,:);
    grid_c_dem_z = grid_c_dem(3:3:end,:);
    
    vertices_idx = vertex_find(grid_c_dem_x, grid_c_dem_y, grid_c_dem_z, proj_coord);
    u_idx = vertices_idx(:,2) / size(grid_c_dem_x,2);
    v_idx = (size(grid_c_dem_x,1) - vertices_idx(:,1)) / size(grid_c_dem_x,1);
    
    %% 이미지 좌표 계산, 화소값 가져오기 // 상대좌표
    xyz_eo = [EO(1) EO(2) EO(3)];
    xy_pcs = image_coordinate(converted_dem, R, xyz_eo, focal_length, pixel_size, pixel_cnt);
    
    FR = pixel_color(pixel_cnt, xy_pcs, img, 1);
    FG = pixel_color(pixel_cnt, xy_pcs, img, 2);
    FB = pixel_color(pixel_cnt, xy_pcs, img, 3);

    %% 각 화소값들 모아서 출력 및 저장
    rgb_image = cat(3, FR, FG, FB);
    
    figure;
    imshow(rgb_image);
    image_output = sprintf('%s_%s', 'rectified', imagelist(i).name);
    imwrite(rgb_image, image_output);
    
    % Generate a ply file
    ply_output = sprintf('%s%s', image_output(1:(end-3)), 'ply');
    fid=fopen(ply_output,'w');
    fprintf(fid,'ply\n');
    fprintf(fid,'format ascii 1.0\n');
    fprintf(fid,'comment author: Hwiyoung Kim\n');
    fprintf(fid,'comment TextureFile %s\n',image_output);
    fprintf(fid,'element vertex 4\n');
    fprintf(fid,'property double x\n');
    fprintf(fid,'property double y\n');
    fprintf(fid,'property double z\n');
    fprintf(fid,'element face 2\n');
    fprintf(fid,'property list uint8 int32 vertex_indices\n');
    fprintf(fid,'property list uchar float texcoord\n');
    fprintf(fid,'end_header\n');
    fprintf(fid,'%f %f %f\n',proj_coord{1}');
    fprintf(fid,'%f %f %f\n',proj_coord{2}');
    fprintf(fid,'%f %f %f\n',proj_coord{3}');
    fprintf(fid,'%f %f %f\n',proj_coord{4}');
    fprintf(fid,'3 2 1 0 6 %f %f %f %f %f %f\n',u_idx(3),v_idx(3),u_idx(2),v_idx(2),u_idx(1),v_idx(1));
    fprintf(fid,'3 3 2 0 6 %f %f %f %f %f %f',u_idx(4),v_idx(4),u_idx(3),v_idx(3),u_idx(1),v_idx(1));
    fclose(fid);
end