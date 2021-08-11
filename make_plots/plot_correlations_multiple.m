subjects=[5,12,16,20,24,29];
numscenes=50;
total_numsubjects=32;
timepoints=[1:3:500];
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];

load('../../DerivedData/after_ridge_multiple_Alexnet_5_333_filtered','all_corr');
%load('../../DerivedData/perm_test_Alexnet_5_622_filtered_mini_avg','standard_error');

[tf,left_idx]=ismember(left,e_list);
[tf,right_idx]=ismember(right,e_list);

avg_corr=zeros(3,length(timepoints));
%plot trialwise model correlation across time
for i=1:length(subjects)
	figure;
	subplot(2,1,1);
	%avg_corr(1,:)=mean(squeeze(all_corr(1,i,left_idx,:)));
	%avg_corr(2,:)=mean(squeeze(all_corr(2,i,left_idx,:)));
	%avg_corr(3,:)=mean(squeeze(all_corr(3,i,left_idx,:)));
	all_corr_avg=reshape(squeeze(all_corr(:,i,left_idx,:)),[size(all_corr,1)*length(left_idx),size(all_corr,4)]);
	x=[timepoints,fliplr(timepoints)];
	y=[mean(all_corr_avg)+std(all_corr_avg),fliplr(mean(all_corr_avg)-std(all_corr_avg))];
	fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
	hold on;
	plot(timepoints,mean(all_corr_avg));
	hold off;
	title('Left side');
	xlabel('Time');
	ylabel('Potential');
	ylim([-0.2,0.6]);
	grid on;
	subplot(2,1,2);
	%avg_corr(1,:)=mean(squeeze(all_corr(1,i,left_idx,:)));
	%avg_corr(2,:)=mean(squeeze(all_corr(2,i,left_idx,:)));
	%avg_corr(3,:)=mean(squeeze(all_corr(3,i,left_idx,:)));
	all_corr_avg=reshape(squeeze(all_corr(:,i,right_idx,:)),[size(all_corr,1)*length(right_idx),size(all_corr,4)]);
	x=[timepoints,fliplr(timepoints)];
	y=[mean(all_corr_avg)+std(all_corr_avg),fliplr(mean(all_corr_avg)-std(all_corr_avg))];
	fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
	hold on;
	plot(timepoints,mean(all_corr_avg));
	hold off;
	title('Right side');
	xlabel('Time');
	ylabel('Potential');
	ylim([-0.2,0.6]);
	grid on;
	saveas(gcf,['../../Figures/plotted_corr/subject_' num2str(subjects(i)) '.jpg']);

end
