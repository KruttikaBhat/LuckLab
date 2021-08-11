function get_scene_correlations(filename,e_list,left,right,subjects,timepoints,numscenes)

load(['../../DerivedData/', filename],'');

[tf,left_idx]=ismember(left,e_list);
[tf,right_idx]=ismember(right,e_list);

corr_scenes_left=zeros(length(subjects),numscenes,length(timepoints));
corr_scenes_right=zeros(length(subjects),numscenes,length(timepoints));

%get trialwise model correlation
for i=1:length(subjects)
	for j=1:length(e_list)
		for k=1:length(timepoints)
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			test_data=[];
			for p=1:numscenes
				test_data=[test_data; file.data(data_idx{1,i,p},:)];
			end
			corr_trials(i,j,k)=corr(test_data(:,1),final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end));
		end
	end
end

%plot trialwise model correlation across time
for i=1:length(subjects)
	figure;
	subplot(2,1,1);
	plot(timepoints,mean(squeeze(corr_trials(i,left_idx,:))));
	title('Left side');
	xlabel('Time');
	ylabel('r');
	ylim([-1,1]);
	subplot(2,1,2);
	plot(timepoints,mean(squeeze(corr_trials(i,right_idx,:))));
	title('Right side');
	xlabel('Time');
	ylabel('r');
	ylim([-1,1]);
	grid on;
	saveas(gcf,['../../Figures/plotted_corr/trials/subject_' num2str(subjects(i))] );

end


end
