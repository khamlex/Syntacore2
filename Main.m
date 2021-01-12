%---Starting pools (finds optimal value)---
parfor i=1:1
    
end

%---Kind of user interface---
disp("--------------------------");
main_dir = input("Type full input files directory: \n",'s');
disp(' ');
test_all = input("You want to test all files in this directory? y/n: \n",'s');
disp(' ');
if ~exist(main_dir + '\res', 'dir')
    mkdir(main_dir + '\res')
end
if test_all == 'y'
    files = dir( fullfile(main_dir,'*.txt'));
    files = {files.name}';
    for i = 1:length(files)
        disp('Analysing ' + num2str(i) + ' of ' + num2str(length(files)) + ' files:')
        tic
        spectr(main_dir, string(files(i)));  
        toc
        disp(' ');
    end
else
    file = input('Type file name you want to test: \n','s');
    disp(' ');
    tic
    spectr(main_dir, file + '.txt');
    toc
end

%---Finding the weight---
function out = spectr(dir, file_in)

    file_out =  dir + '\res\' + erase(file_in, '.txt') + '_res.txt';
    fid = fopen(dir + '\'+ file_in);
    TextIn = textscan(fid, '%s');
    fclose(fid);
    DataRow = split(string(TextIn{:}), '');
    DataRow = DataRow(:, 2:size(DataRow,2)-1);
    In = logical(str2double(DataRow()));
    clear fid TextIn DataRow;
    row = size(In, 1);
    col = size(In, 2);
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
    
    writematrix(Out, file_out, 'Delimiter','\t')
    out = Out;
    
end

%---Some number to its bunary---
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