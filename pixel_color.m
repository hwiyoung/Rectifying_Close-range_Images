function rgb = pixel_color(pixel_cnt, xy_fcs, em, k)
    i_e=size(xy_fcs,1);     % row
    j_e=size(xy_fcs,2);     % column
    
    for row = 1 : i_e       % row
        for col = 1 : j_e   % column
            if xy_fcs{row, col}(1) < 0 || xy_fcs{row, col}(1) > pixel_cnt(2)      % column
            elseif xy_fcs{row, col}(2) < 0 || xy_fcs{row, col}(2) > pixel_cnt(1)  % row
            else
                FR(row,col)=em(ceil(xy_fcs{row, col}(2)), ceil(xy_fcs{row, col}(1)), k);    % em(row, col)
            end
        end
    end
    rgb=FR;    
end
