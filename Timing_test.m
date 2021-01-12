tests = 50;
test_time = zeros(tests, 2);
for w = 1:tests
    row = randi([10 20]);
    col = randi([50 100])*10;
    time_estimated = a_val(2)*exp(polyval(b_val, col)*row);
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
    test_time(w, 1) = time_estimated;
    test_time(w, 2) = toc;
end
x = 1:length(test_time);
y = test_time(:, 1);
scatter(x, y, 'filled');
hold on
scatter(x, test_time(:,2), 'filled');
disp(corrcoef(y, test_time(:,2)));
set(gcf,'color','w', 'Position', [960, 0, 700, 600]);
xlabel('Test id');
ylabel('Time');
legend('Estimated time','Real time')

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