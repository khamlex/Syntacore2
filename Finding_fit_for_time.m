f1 = figure;
set(gcf,'color','w', 'Position', [960, 0, 700, 600]);
coeffvals = zeros(size(Data_time, 2), 2);
for i = 1:size(Data_time, 2)
    y = 1:size(Data_time, 1);
    y = y';
    x = 1:size(Data_time, 1);
    x(:) = i*100;
    x = x';
    z = Data_time(:, i);
    [b_val, b] = createFit(y, z, 'exp1');
    z_ap = b_val(y);
    plot3(x, y, z, 'color', 'blue');
    hold on
    plot3(x, y, z_ap, 'color', 'red');
    coeffvals(i, :) = coeffvalues(b_val);
    xlabel('Vectors length');
    ylabel('Vectors number');
    zlabel('Time');
end
grid on
title('Fitting with t = a\ite^{b x}');

f2 = figure;
set(gcf,'color','w', 'Position', [960, 0, 700, 600]);
coeffvals = zeros(size(Data_time, 2), 2);
for i = 1:size(Data_time, 2)
    y = 1:size(Data_time, 1);
    y = y';
    x = 1:size(Data_time, 1);
    x(:) = i*100;
    x = x';
    z = Data_time(:, i);
    [b_val, b] = createFit(y, z, 'exp1');
    z_ap = b_val(y);
    plot3(x, y, log(z), 'color', 'blue');
    hold on
    plot3(x, y, log(z_ap), 'color', 'red');
    coeffvals(i, :) = coeffvalues(b_val);
    xlabel('Vectors length');
    ylabel('Vectors number');
    zlabel('Time');
end
grid on
title('Fitting with log(t) = log(a) + b x');

f3 = figure;
set(gcf,'color','w', 'Position', [960, 0, 700, 600]);
x = (100:100:100*size(coeffvals, 1))';
y = coeffvals(:, 2);
plot(x, y);
hold on
b_val = polyfit(x, y, 1);
y_ap = polyval(b_val, x);
plot(x, y_ap);
xlabel('Vectors length');
ylabel(' b at y = a\ite^{b x}');
grid on
title('"b" coefficient');

f4 = figure;
set(gcf,'color','w', 'Position', [960, 0, 700, 600]);
x = (100:100:100*size(coeffvals, 1))';
y = coeffvals(:, 1);
plot(x, y);
hold on
a_val = polyfit(x, y, 1);
y_ap = polyval(a_val, x);
plot(x, y_ap);
xlabel('Vectors length');
ylabel('a at y = a\ite^{b x}');
grid on
title('"a" coefficient');

f5 = figure;
set(gcf,'color','w', 'Position', [960, 0, 700, 600]);
y = 1:20;
y =y';
x = 100:100:100*10;
x = x';
[X, Y] = meshgrid(x, y);
F = a_val(2)*exp(polyval(b_val, X).*Y);
surf(X, Y, F,'FaceColor','r');
hold on
F = Data_time;
mesh(X, Y, F,'FaceColor','g');
xlabel('Vectors length');
ylabel('Vectors number');
zlabel('Time');
grid on
legend('Estimated time', 'Real time')
function [fitresult, gof] = createFit(x_fit, z_fit, type)

    [xData, yData] = prepareCurveData( x_fit, z_fit );
    ft = fittype(type);
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.0045 0.0034];
    [fitresult, gof] = fit(xData, yData, ft, opts);

end
