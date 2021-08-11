load('../../DerivedData/after_linear_scenewise_teardrop_2_averagetrials_alexnet_3_leftright_allsubjects_256scenes');
load('../../Predictors/location_index_quadrants');

subjects=[1:16];
timepoints=[1:3:750];

%subjects=[1:3];
%timepoints=[1:3:500];

scalp_map='../../Data/27_electrodes_leftright.ced';

to_plot_upperleft=squeeze(mean(mean(betas(:,find(sceneindex==3),:,:),2)))';
to_plot_upperright=squeeze(mean(mean(betas(:,find(sceneindex==4),:,:),2)))';
to_plot_lowerleft=squeeze(mean(mean(betas(:,find(sceneindex==1),:,:),2)))';
to_plot_lowerright=squeeze(mean(mean(betas(:,find(sceneindex==2),:,:),2)))';

step=50;
vals_upperleft=[];
vals_upperright=[];
vals_lowerleft=[];
vals_lowerright=[];

for count=min(timepoints):step:max(timepoints)
        idx=find(timepoints<count+step & timepoints>=count);
	vals_upperleft=[vals_upperleft; mean(to_plot_upperleft(:,idx),2)'];
	vals_upperright=[vals_upperright; mean(to_plot_upperright(:,idx),2)'];
	vals_lowerleft=[vals_lowerleft; mean(to_plot_lowerleft(:,idx),2)'];
        vals_lowerright=[vals_lowerright; mean(to_plot_lowerright(:,idx),2)'];
        count
end

lim=[min([vals_upperleft(:); vals_upperright(:); vals_lowerleft(:); vals_lowerright(:)]) max([vals_upperleft(:); vals_upperright(:); vals_lowerleft(:); vals_lowerright(:)])];


plot_beta(lim,vals_upperleft,timepoints,scalp_map,'UpperLeft');
plot_beta(lim,vals_upperright,timepoints,scalp_map,'UpperRight');
plot_beta(lim,vals_lowerleft,timepoints,scalp_map,'LowerLeft');
plot_beta(lim,vals_lowerright,timepoints,scalp_map,'LowerRight');

function plot_beta(lim,vals,timepoints,scalp_map,name)

step=50;
count=min(timepoints);
for i=1:size(vals,1)
	figure;
	to_plot=vals(i,:)
	topoplot(to_plot,scalp_map,'maplimits',lim,'colormap',jet,'conv','on','interplimits','electrodes');
	c = colorbar;
	set(c,'YLim',lim,'fontsize',12);
	title([name,' - Timepoints ',num2str(count),'-',num2str(count+step)]);
	saveas(gcf,['../../Figures/plotted_corr/',name,'_timepoint_',num2str(count),'.png']);
	count=count+step;
end

end
