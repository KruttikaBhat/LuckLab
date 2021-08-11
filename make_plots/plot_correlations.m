%subjects=[1:32];
%numscenes=50;
%total_numsubjects=32;
%timepoints=[1:3:500];

%iaps
subjects=[1:29];
scenes=[1:44];
timepoints=[1:3:500];

%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53,];
%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53,];

e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
%e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];

%scalp_map='../../Data/59_CED_occipital.ced';

%subjects=[1:16];
%channels=[1:10];
%timepoints=[100:375];
%e_list=[1:27];

if(~(exist('../../Figures/plotted_corr')))
	mkdir('../../Figures/plotted_corr');
end


load('../../DerivedData/after_fitrlinear_iaps_random_192','final_corr');
%load('../../DerivedData/perm_test_Alexnet_5_622_filtered_mini_avg','standard_error');

%[tf,left_idx]=ismember(left,e_list);
%[tf,right_idx]=ismember(right,e_list);

all_sub_elec=zeros(length(e_list),length(timepoints));
for i=1:length(e_list)
	to_plot=squeeze(final_corr(:,i,:));
	all_sub_elec(i,:)=mean(to_plot);
	figure;
	x=[timepoints,fliplr(timepoints)];
	y=[mean(to_plot)+std(to_plot),fliplr(mean(to_plot)-std(to_plot))];
	fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
	hold on;
	plot(timepoints,mean(to_plot));
	title(['Electrode ',num2str(e_list(i))]);
	xlabel('Time');
	ylabel('Correlation');
	ylim([-0.2,0.6]);
	grid on;
	saveas(gcf,['../../Figures/plotted_corr/electrode_',num2str(e_list(i)),'.jpg']);
end


%figure;
%count=1;
%%all_sub_elec_mod=[all_sub_elec(4,:);all_sub_elec(3,:);all_sub_elec(2,:);all_sub_elec(1,:);all_sub_elec(6,:);all_sub_elec(7,:);all_sub_elec(8,:);all_sub_elec(12,:);all_sub_elec(11,:);all_sub_elec(10,:);all_sub_elec(9,:);all_sub_elec(15,:);all_sub_elec(14,:);all_sub_elec(16,:);all_sub_elec(5,:);all_sub_elec(13,:)];
%vals=[];
%while count<500
%	idx=find(timepoints<count+50 & timepoints>=count);
%	vals=[vals; mean(all_sub_elec(:,idx),2)'];
%	count=count+50;
%end
%
%lim=[min(vals(:)) max(vals(:))];
%
%for i=1:size(vals,1)
%	figure;
%	to_plot=vals(i,:)
%	topoplot(to_plot,scalp_map,'maplimits',lim,'colormap',jet);
%	c = colorbar;
%	set(c,'YLim',lim,'fontsize',12);
%	title(['Timepoints ',num2str((i-1)*50+1),'-',num2str(i*50)]);
%	saveas(gcf,['../../Figures/plotted_corr/timepoint_',num2str((i-1)*50+1),'.png']);
%end


to_plot=squeeze(mean(final_corr,1));
figure;
x=[timepoints,fliplr(timepoints)];
y=[mean(to_plot)+std(to_plot),fliplr(mean(to_plot)-std(to_plot))];
fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
hold on;
plot(timepoints,mean(to_plot));
title('All subjects then electrode avg');
xlabel('Time');
ylabel('Correlation');
ylim([-0.2,0.6]);
grid on;
saveas(gcf,'../../Figures/plotted_corr/all_sub_elec.jpg')

%plot trialwise model correlation across time

for i=1:length(subjects)
	to_plot=squeeze(final_corr(i,:,:));
	figure;
	x=[timepoints,fliplr(timepoints)];
	y=[mean(to_plot)+std(to_plot),fliplr(mean(to_plot)-std(to_plot))];
	fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
	hold on;
	plot(timepoints,mean(to_plot));
	title(['Subject ',num2str(subjects(i)),'.jpg']);
	xlabel('Time');
	ylabel('Correlation');
	ylim([-0.2,0.6]);
	grid on;
	saveas(gcf,['../../Figures/plotted_corr/subject_' num2str(subjects(i)) '.jpg']);

end


%if(~exist('../../Figures/plotted_corr/left_right'))
%	mkdir('../../Figures/plotted_corr/left_right');
%end
%
%for i=1:length(subjects)
%	figure;
%	subplot(2,1,1);
%	%plot(timepoints,mean(squeeze(standard_error(i,left_idx,:))));
%	plot(timepoints,mean(squeeze(final_corr(i,left_idx,:))));
%	title('Left side');
%	xlabel('Time');
%	ylabel('Correlation');
%	ylim([-0.2,0.6]);
%	grid on;
%	subplot(2,1,2);
%	%plot(timepoints,mean(squeeze(standard_error(i,right_idx,:))));
%	plot(timepoints,mean(squeeze(final_corr(i,right_idx,:))));
%	title('Right side');
%	xlabel('Time');
%	ylabel('Correlation');
%	ylim([-0.2,0.6]);
%	grid on;
%	saveas(gcf,['../../Figures/plotted_corr/left_right/subject_' num2str(subjects(i)) '.jpg']);
%
%end


to_plot=squeeze(mean(final_corr,2));
figure;
x=[timepoints,fliplr(timepoints)];
y=[mean(to_plot)+std(to_plot),fliplr(mean(to_plot)-std(to_plot))];
fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
hold on;
plot(timepoints,mean(to_plot));
title('All electrodes then subjects avg');
xlabel('Time');
ylabel('Correlation');
ylim([-0.2,0.6]);
grid on;
saveas(gcf,'../../Figures/plotted_corr/all_elec_sub.jpg')


figure;
plot(timepoints,mean(to_plot)./std(to_plot));
title('All electrodes then subjects avg');
xlabel('Time');
ylabel('Effective Correlation (mean/stdev)');
%ylim([-1,1]);
grid on;
saveas(gcf,'../../Figures/plotted_corr/all_elec_sub_effec.jpg')
