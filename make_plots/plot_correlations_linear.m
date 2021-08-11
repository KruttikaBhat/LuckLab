load('../../DerivedData/after_linear_scenewise_teardrop_2_quadrantsplitencode_leftright_allsubjects_256scenes.mat');

subjects=[1:16];
timepoints=[1:3:750];

%subjects=[1:10];
%timepoints=[1:3:500];


%to_plot=squeeze(mean(final_corr,2));
to_plot=stacked_corr; %([3,6,10,11,12,15],:); 
stderror= std(to_plot)./sqrt(size(to_plot,1));
figure;
x=[timepoints,fliplr(timepoints)];
y=[mean(to_plot)+stderror,fliplr(mean(to_plot)-stderror)];
fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
hold on;
plot(timepoints,mean(to_plot));
title('Teardrop 2, Quadrant encoding, left-right electrodes, Scene Split, 256 Scenes');
xlabel('Time');
ylabel('Correlation');
ylim([-0.5,0.7]);
yticks(-0.5:0.1:0.7);
grid on;
saveas(gcf,'../../Figures/plotted_corr/all_pixel_sub.jpg')



%for i=1:length(subjects)
%	to_plot=squeeze(final_corr(i,:,:));
%	figure;
%        x=[timepoints,fliplr(timepoints)];
%        y=[mean(to_plot)+std(to_plot),fliplr(mean(to_plot)-std(to_plot))];
%        fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
%        hold on;
%        plot(timepoints,mean(to_plot));
%        title(['Subject ',num2str(subjects(i)),'.jpg']);
%        xlabel('Time');
%        ylabel('Correlation');
%        %ylim([-0.2,0.6]);
%        grid on;
%        saveas(gcf,['../../Figures/plotted_corr/subject_' num2str(subjects(i)) '.jpg']);
%end
%
