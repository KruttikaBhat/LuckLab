clear;
load('../../DerivedData/after_ridge_Alexnet_5_each_scene');
load('../../DerivedData/after_grand_mean_subtraction','numtrials');
addpath('../stock_functions');
subjects=[1,3,7,8,22,26];
timepoints=[1:125,126:3:500];
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];
scenes=[1:3];

all_corr_avg={};
all_corr_avg{1}=types_of_plots(left,"left",timepoints,subjects,final_ridge,numtrials,scenes,data_idx);
all_corr_avg{2}=types_of_plots(right,"right",timepoints,subjects,final_ridge,numtrials,scenes,data_idx);
%all_corr_avg{3}=types_of_plots(e_list,"all",timepoints,subjects,final_ridge,numtrials,scenes,data_idx);

for i=1:3
	a=[];
	for j=1:3
		a=[a mean2(all_corr_avg{i}{j})];
	end
	disp(a);
end

%save('../../DerivedData/model_correlation/Alexnet_layer5_each_scene','all_corr_avg');

function all_corr=types_of_plots(current_list,type,timepoints,subjects,final_ridge,numtrials,scenes,data_idx)
numscenes=length(scenes);
pred_sub=zeros(numscenes,length(subjects),length(timepoints));
actual_sub=zeros(numscenes,length(subjects),length(timepoints));

all_corr=cell(1,3);
all_corr{1}=zeros(1,numscenes);
all_corr{2}=zeros(length(subjects),numscenes);
all_corr{3}=zeros(length(subjects),length(current_list),numscenes);


for i=1:length(subjects)
	tic
	pred_elec=zeros(numscenes,length(current_list),length(timepoints));
	actual_elec=zeros(numscenes,length(current_list),length(timepoints));
	for j=1:length(current_list)
		pred=zeros(numscenes,length(timepoints));
		actual=zeros(numscenes,length(timepoints));
		parfor k=1:length(timepoints)
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),current_list(j),timepoints(k)));
			for p=1:numscenes
				req_data=file.data(data_idx{3,i,scenes(p)},:);
				pred(p,k)=mean(final_ridge{i,j,k}(1)+req_data(:,2:end)*final_ridge{i,j,k}(2:end));
				actual(p,k)=mean(req_data(:,1));
			end
		end
		for p=1:numscenes
			t_p=pred(p,:);
			t_a=actual(p,:);
			title_name=['Subject-' num2str(subjects(i)) ' Electrode-' num2str(current_list(j)) ' Scene-' num2str(scenes(p))];
			filename=['../../Figures/pred_waveforms/'+type+'/predicted_Subject_Electrode/'+title_name+'.png'];
			plot_waveform(title_name,filename,timepoints,t_a,t_p);
			pred_elec(p,j,:)=t_p;
			actual_elec(p,j,:)=t_a;
			all_corr{3}(i,j,p)=corr(t_p',t_a');
		end	
	end
	for p=1:numscenes
		t_p=squeeze(mean(pred_elec(p,:,:),2))';
		t_a=squeeze(mean(actual_elec(p,:,:),2))';
		title_name=['Subject-' num2str(subjects(i)) ' Scene-' num2str(scenes(p))];
		filename=['../../Figures/pred_waveforms/'+type+'/predicted_Subject/'+title_name+'.png'];
		plot_waveform(title_name,filename,timepoints,t_a,t_p);
		pred_sub(p,i,:)=t_p;
		actual_sub(p,i,:)=t_a;
		all_corr{2}(i,p)=corr(t_p',t_a');
	end
	toc
end

for p=1:numscenes
	t_p=squeeze(mean(pred_sub(p,:,:),2))';
	t_a=squeeze(mean(actual_sub(p,:,:),2))';
	title_name=['Scene-' num2str(scenes(p))];
	filename=['../../Figures/pred_waveforms/'+type+'/predicted/'+title_name+'.png'];
	plot_waveform(title_name,filename,timepoints,t_a,t_p);
	all_corr{1}(1,p)=corr(t_p',t_a');
end


%all_avg=[mean2(corr_sub),mean2(corr_elec),mean2(corr_indi)];
end


function plot_waveform(title_name,filename,x,t_a,t_p)

figure;
plot(x,t_a,'-',x,t_p,'-.');
grid on;
%ylim([-1 1]);
xlabel('Time');
ylabel('Potential');
title(title_name);
legend('actual','predicted');
saveas(gcf,filename);

end
