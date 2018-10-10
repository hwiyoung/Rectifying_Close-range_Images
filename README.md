# Rectifying_Close-range_Images

## Input
* Input folder
  * Images to rectify
* in Code
  * 3-points on the target plane (**p{1}, p{2}, p{3}**)
  * Pixel size
  * Focal length
  * GSD(using **computeGSD** function)
***

## Output
* Rectified images(2D) - .png
* Rectified images(3D) - .ply
***

## Input & Output
Input | Output
--------- | ---------
![Original image](./Figures/IMG_0050.jpg) | ![Rectified image](./Figures/rectified_IMG_0050.jpg)

## Output in 3D
![Output in 3D](./Figures/OutputIn3D.png)
***

## How to use
### Run ortho.m !!!(main code)

## Flow in this module
1. ortho.m - Execution Code
2. vertex_g.m
3. xy_g_min.m(executed in vertex_g.m)
4. computeGSD.m
5. dem_m.m
6. convert_dem.m
7. image_coordinate.m
8. pixel_color.m
9. vertex_find.m
10. (Generate a ply file)

## Log
* Add a function to generate ply files - 10/10/18