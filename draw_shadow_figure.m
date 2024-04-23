
width = 230;
height = 180;
figure('Position', [40, 40, width, height]);

score2(:,2:729) = 1-max(1-score2(:,2:729),0).^3.2;

num = 50;
for i = 1:(num)/2
    temp = quantile(score2',(i/num));
    temp1 = quantile(score2',(1-i/num));
    temp = temp(1:12);
    temp1 = temp1(1:12);
    fill([0:11,12,12:-1:0],[temp,1,1,temp1(12:-1:1)],'r','FaceAlpha',1/num,'EdgeColor','none');
    hold on
end

temp = quantile(score2',(0.5));
temp = temp(1:12);
plot(0:12,[temp,1],'k','LineWidth',2)

temp = quantile(score2',(0.8));
temp = temp(1:12);
plot(0:12,[temp,1],'k--','LineWidth',2)

temp = quantile(score2',(0.2));
temp = temp(1:12);
plot(0:12,[temp,1],'k--','LineWidth',2)
xlim([0,12])
ylim([0.4,1])
grid on 

score2(:,1) = [];
temp = (randsample(length(score2)-1,1000,'true'))+1;
score2_7= score2(:,temp);