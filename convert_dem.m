% converting a defiend grid to original coordinate system
% 2016. 09. 19
% Hwiyoung Kim

function converted_dem = convert_dem(u, dem)
    row = size(dem, 1); col = size(dem,2);
    converted_dem = cell(row, col);
    for a=1:row
        for b=1:col
            converted_dem{a,b} = u * dem{a,b}';
        end
    end
end