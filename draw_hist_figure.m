width = 230;
height = 180;
figure('Position', [40, 40, width, height]);

hist([score1(1,temp);score1(2,temp);score1(3,temp);score1(6,temp);score1(12,temp)]')
legend('immdiate','one month','two months','half a year','a year')
xlim([0,1])
grid on

score1_6 = score1(:,temp);
