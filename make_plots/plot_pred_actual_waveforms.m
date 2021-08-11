clear;
load('../DerivedData/after_ridge_Alexnet_5');
load('../DerivedData/after_grand_mean_subtraction','numtrials');
subjects=[1,3,7,8,22,26];
timepoints=[101:125,126:3:500];
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];
current_list=left;
type="left";

timepoints_pred_grand={};
timepoints_actual_grand={};
common_scenes_sub=[];
for i=1:length(subjects)
	timepoints_pred_elec={};
	timepoints_actual_elec={};
	common_scenes_elec=[];
	for j=1:length(current_list)
		common_scenes=[];
		for t_idx=1:length(timepoints)
			t=timepoints(t_idx);
			scenes=unique(numtrials{subjects(i)}(find(test_data_idx{i,j,t_idx}==1)));
			if t_idx==1
				common_scenes=scenes;
			else
				common_scenes=intersect(common_scenes,scenes);
			end
		end
		if j==1
			common_scenes_elec=common_scenes;
		else
			common_scenes_elec=intersect(common_scenes_elec,common_scenes);
		end
		timepoints_pred=zeros(length(common_scenes),length(timepoints));
		timepoints_actual=zeros(length(common_scenes),length(timepoints));
		for k=1:length(common_scenes)
			for t_idx=1:length(timepoints)
				file=parload(sprintf(['..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),current_list(j),timepoints(t_idx)));
				test_data= file.data(test_data_idx{i,j,t_idx},:);
				test_data=test_data(numtrials{i}(find(test_data_idx{i,j,t_idx}==1))==common_scenes(k),:);
				timepoints_pred(k,t_idx)=mean(final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end));
				timepoints_actual(k,t_idx)=mean(test_data(:,1));
			end
			title_name=['Subject-' num2str(subjects(i)) ' Electrode-' num2str(current_list(j)) ' Scene-' num2str(common_scenes(k))];
			filename=['../Figures/'+type+'/predicted_Subject_Electrode/'+num2str(common_scenes(k))+'.png'];
			plot_waveform(title_name,filename,timepoints,timepoints_actual(k,:),timepoints_pred(k,:));
			if ismember(common_scenes(k),common_scenes_elec)
				if isempty(timepoints_pred_elec{common_scenes(k)}) 
					timepoints_pred_elec{common_scenes(k)}=timepoints_pred(k,:);
					timepoints_actual_elec{common_scenes(k)}=timepoints_actual(k,:);
				else
					timepoints_pred_elec{common_scenes(k)}=[timepoints_pred_elec{common_scenes(k)}; timepoints_pred(k,:)];
					timepoints_actual_elec{common_scenes(k)}=[timepoints_actual_elec{common_scenes(k)}; timepoints_actual(k,:)];
				end
			end
		end

	end
	if i==1
		common_scenes_sub=common_scenes_elec;
	else
		common_scenes_sub=intersect(common_scenes_sub,common_scenes_elec);
	end
	for j=1:length(common_scenes_elec)
		t_p=mean(timepoints_pred_elec{common_scenes_elec(j)});
		t_a=mean(timepoints_actual_elec{common_scenes_elec(j)});
		title_name=['Subject-' num2str(subjects(i))  ' Scene-' num2str(common_scenes_elec(j))];
		filename=['../Figures/', type, '/predicted_Subject/' num2str(common_scenes_elec(j)) '.png'];
		plot_waveform(title_name,filename,timepoints,t_a,t_p);
		if ismember(common_scenes_elec(j),common_scenes_sub)
			if isempty(timepoints_pred_grand{common_scenes_elec(j)}) 
				timepoints_pred_grand{common_scenes_elec(j)}=t_p;
				timepoints_actual_grand{common_scenes_elec(j)}=t_a;
			else
				timepoints_pred_grand{common_scenes_elec(j)}=[timepoints_pred_grand{common_scenes_elec(j)}; t_p];
				timepoints_actual_grand{common_scenes_elec(j)}=[timepoints_actual_grand{common_scenes_elec(j)}; t_a];
			end
		end

	end
	
end
for i=1:length(common_scenes_sub)
	t_p=mean(timepoints_pred_grand{common_scenes_sub(i)});
	t_a=mean(timepoints_actual_grand{common_scenes_sub(i)});
	title_name=['Scene-' num2str(common_scenes_sub(i))];
	filename=['../Figures/', type, '/predicted/' num2str(common_scenes_sub(i)) '.png'];
	plot_waveform(title_name,filename,timepoints,t_a,t_p);
end


function plot_waveform(title_name,filename,x,t_a,t_p)

figure;
plot(x,t_a,'-',x,t_p,'-.');
grid on;
ylim([-30 30]);
xlabel('Time');
ylabel('Potential');
title(title_name);
legend('actual','predicted');
saveas(gcf,filename);

end
