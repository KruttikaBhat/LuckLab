subjects=[1:16];
timepoints=[1:3:750];

%subjects=[1:10];
%timepoints=[1:3:500];

load('../../DerivedData/after_linear_within_scene_teardrop_2_leftrightsplitencode_occipital_allsubjects_256scenes.mat');
corr_leftright=stacked_corr;
stderror_leftright= std(corr_leftright)./sqrt(size(corr_leftright,1));
to_plot_leftright=mean(corr_leftright)./stderror_leftright;

load('../../DerivedData/after_linear_within_scene_teardrop_2_quadrantsplitencode_occipital_allsubjects_256scenes.mat');
corr_quad=stacked_corr;
stderror_quad= std(corr_quad)./sqrt(size(corr_quad,1));
to_plot_quad=mean(corr_quad)./stderror_quad;

figure;
plot(timepoints,to_plot_leftright,'b',timepoints,to_plot_quad,'r');
title('Teardrop 2, Scene Encoding, occipital electrodes, Trial Split, 256 Scenes');
xlabel('Time');
ylabel('Effect Size');
ylim([-4,12]);
yticks(-4:2:12);
legend('left/right','quadrants');
grid on;
saveas(gcf,'../../Figures/plotted_corr/all_pixel_sub.jpg')
