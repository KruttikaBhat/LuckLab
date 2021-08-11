%scenes=[1:3];
%subjects=[1:32];
%numscenes=3;
%total_numsubjects=32;
%timepoints=[1:3:500];

%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53,];
%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53,];

%occipital region
%e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
%left=[11,10,9,8,43,12,13,14];
%right=[24,23,22,21,59,26,25,27];


subjects=[1:16];
scenes=[1:10]; %channels
timepoints=[100:375];
e_list=[1:27];

load('../../DerivedData/after_ridge_teardrop_alexnet_5');

parent_folder='../../DerivedData/model_data';
%gms_filename='../../DerivedData/after_grand_mean_subtraction_filtered';
%load('../../Predictors/Saliency_predictor_64');
%get_model_data(predictor,e_list,subjects,scenes,timepoints,gms_filename,parent_folder);

subject_avg=zeros(length(subjects),length(timepoints));
for i=1:length(subjects)
	tic;
	electrode_avg=zeros(length(e_list),length(timepoints));
        for j=1:length(e_list)
		model_corr=zeros(1,length(timepoints));
                parfor k=1:length(timepoints)
			file=parload(sprintf(['../../DerivedData/model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			train_test=zeros(length(scenes),2);
			train=[];
			test=[];
                        for p=1:length(scenes)
				rem_data=[file.data(data_idx{3,i,p},1);file.data(data_idx{2,i,p},1)];
				train_test(p,1)=mean(rem_data);
				train_test(p,2)=mean(file.data(data_idx{1,i,p},1));
				test_count=length(data_idx{1,i,p});
				train=[train; repmat(train_test(p,1),test_count,1)];
				test=[test; file.data(data_idx{1,i,p},1)];
				%for getting corr when split is based on scenes
				%train_test(p,1)=mean(file.data(1:data_idx(1,i)-1,1)); %train data
				%train_test(p,2)=mean(file.data(data_idx(1,i):end,1)); %test data
                        end
                        %model_corr(1,k)=corr(train_test(:,1),train_test(:,2));
			model_corr(1,k)=corr(train,test);
			%pred=final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end);
		end
		electrode_avg(j,:)=model_corr;
	end
	subject_avg(i,:)=nanmean(electrode_avg);
	toc;
end

figure;
x=[timepoints,fliplr(timepoints)];
y=[mean(subject_avg)+std(subject_avg),fliplr(mean(subject_avg)-std(subject_avg))];
fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
hold on;
plot(timepoints,mean(subject_avg));
title('Correlation between training and testing sets');
xlabel('Time');
ylabel('Correlation');
ylim([-0.2,0.6]);
grid on;
saveas(gcf,'../../Figures/train_test_corr_as_is.jpg')
