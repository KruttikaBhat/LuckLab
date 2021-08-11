scenes=[1:3];
subjects=[1:32];
numscenes=3;
total_numsubjects=32;
timepoints=[1:3:500];

%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53,];
%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53,];

%occipital region
e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];

%load('../../DerivedData/after_ridge_Saliency_mean_3scenes_622_filtered_all_subjects');
%
%parent_folder='../../DerivedData/model_data';
%gms_filename='../../DerivedData/after_grand_mean_subtraction_filtered';
%%load('../../Predictors/Saliency_predictor_64');
%%get_model_data(predictor,e_list,subjects,scenes,timepoints,gms_filename,parent_folder);
%
%subject_avg=zeros(length(subjects),length(timepoints));
%for i=1:length(subjects)
%	tic;
%	electrode_avg=zeros(length(e_list),length(timepoints));
%        for j=1:length(e_list)
%		model_corr=zeros(1,length(timepoints));
%                parfor k=1:length(timepoints)
%			file=parload(sprintf(['../../DerivedData/model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
%			train_data=[];
%			valid_data=[];
%			test_data=[];
%			for p=1:length(scenes)
%				train_data=[train_data; file.data(data_idx{3,i,p},:)];
%				valid_data=[valid_data; file.data(data_idx{2,i,p},:)];
%				test_data=[test_data; file.data(data_idx{1,i,p},:)];
%			end
%			rem_data=[train_data;valid_data];
%			model_corr(1,k)=final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end);
%		end
%		electrode_avg(j,:)=model_corr;
%	end
%	subject_avg(i,:)=mean(electrode_avg);
%	toc;
%end
%
%figure;
%x=[timepoints,fliplr(timepoints)];
%y=[mean(subject_avg)+std(subject_avg),fliplr(mean(subject_avg)-std(subject_avg))];
%fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
%hold on;
%plot(timepoints,mean(subject_avg));
%title('Correlation between training and testing sets');
%xlabel('Time');
%ylabel('Correlation');
%ylim([-0.2,0.6]);
%grid on;
%saveas(gcf,'../../Figures/train_test_corr.jpg')
%


load('../../DerivedData/after_ridge_Saliency_mean_3scenes_622_filtered_all_subjects','final_ridge');

i=14
%timepoints=[[1:3:500]-125];
for j=1:length(e_list)
	all=[];
	left=[];
	right=[];
	for k=1:length(timepoints)
		all=[all final_ridge{i,j,k}(2)];
		left=[left final_ridge{i,j,k}(3)];
		right=[right final_ridge{i,j,k}(4)];
	end
	figure;
	plot(timepoints,all,'r',timepoints,left,'b',timepoints,right,'g');
	legend('1','2','3');
	xlabel('Time');
	ylabel('Beta coefficient value');
	title(['Subject 1, Electrode ',num2str(e_list(j))]);
	saveas(gcf,['../../Figures/plotted_coeff/electrode_',num2str(e_list(j)),'.jpg']);
end
