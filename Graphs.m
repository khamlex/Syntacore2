sca = 100;
row_max = 20;
col_max = 10;
Data_vals = cell(row_max, col_max);
Data_time = zeros(row_max, col_max);
n = 0;
for row_i = 1:row_max
    for col_i = 1:col_max
        row = row_i;
        col = col_i*sca;
        In = logical(randi([0, 1], [row, col]));
        tic
        Sum = zeros(1,2^row);
        parfor i = 1:2^row
            Mid = logical(zeros(1, col));
            scale = bin2vec(i - 1, row);
            for j = 1:row
                if scale(j) ~= 0 && sum(In(j, :)) ~= 0
                    Mid = xor(Mid, In(j, :));
                end
            end
            Sum(i) = sum(Mid);
        end

        Out = zeros(col + 1, 2);
        Out(:,1) = 0:col;

        for i = 1:2^row
            col = Sum(i) + 1;
            Out(col, 2) = Out(col, 2) + 1;
        end
        Data_vals{row_i, col_i} = Out;
        Data_time(row_i, col_i) = toc;
        n = n+1;
        disp(num2str(n/(row_max*col_max)));
    end
end

function out = bin2vec(data,nBits)
    powOf2 = 2.^[0:nBits-1];
    out = false(1, nBits);
    ct = nBits;
    while data > 0
        if data >= powOf2(ct)
            data = data - powOf2(ct);
            out(ct) = true;
        end
        ct = ct - 1;
    end
end
