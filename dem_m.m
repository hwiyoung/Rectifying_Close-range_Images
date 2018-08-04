% 격자점 생성
% 2013. 04. 04 
% 전의익
% 19.09.2016 modified by Hwiyoung Kim

function dem = dem_m(gc, row, col, gsd, Ground_height)
    dem = cell(row, col);
    for a=1:row
        for b=1:col
%             dem{a,b}(1,:)=[gc(4)-(a-1)*gsd, gc(1)+(b-1)*gsd, Ground_height];
            dem{a,b}(1,:)=[gc(1)+(b-1)*gsd, gc(4)-(a-1)*gsd, Ground_height];
%             dem{a,b}(1,:)=[gc(1)+(b-1)*gsd, gc(3)+(a-1)*gsd, Ground_height];
        end
    end
end