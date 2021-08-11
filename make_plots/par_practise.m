clear;
load('../DerivedData/after_ridge_Alexnet_5');
%e_list=[38, 6, 5, 20, 53, 35, 33, 48, 50, 4, 3, 2, 18, 19, 44, 28, 1, 17, 42, 40, 57, 54, 10, 8, 7, 21, 23, 13, 25, 16];
%red=[10,8,7,21,23,13,25,16];
%green=[1,17,28,44,4,3,2,18,19,35,33,48,50,38,6,5,20,53];
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];


[tf,left_idx]=ismember(left,e_list);
[tf,right_idx]=ismember(right,e_list);
subjects=[1,3,7,8,22,26];
timepoints=[101:125,126:3:500];
current_idx=left_idx;
timepoints_grand_pred=zeros(length(subjects),length(timepoints));
timepoints_grand_actual=zeros(length(subjects),length(timepoints));
for i=1:1
	tic;
	timepoints_pred=zeros(length(e_list),length(timepoints));
	timepoints_actual=zeros(length(e_list),length(timepoints));
	for j=1:length(current_idx)
		parfor k=1:length(timepoints)
			file=parload(sprintf(['..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),left(j),timepoints(k)));
			test_data= file.data(test_data_idx{i,j,k},:);
			timepoints_pred(j,k)=mean(final_ridge{i,j,k}(1)+test_data(1,2:end)*final_ridge{i,j,k}(2:end));
			timepoints_actual(j,k)=mean(test_data(1,1));
			
		end
		figure;
		plot(timepoints,timepoints_actual(j,:),'-',timepoints,timepoints_pred(j,:),'-.');
		grid on;
		ylim([-1 1]);
		xlabel('Time');
		ylabel('Potential');
		title(['Electrode ' num2str(left(j))]);
		legend('actual','predicted');
		saveas(gcf,['../Figures/predicted_Subject1/left/' num2str(left(j)) '.png']);
	end
%	figure;
%	plot(timepoints,mean(timepoints_actual),'-',timepoints,mean(timepoints_pred),'-.');
%	grid on;
%	ylim([-100 100]);
%	xlabel('Potential');
%	ylabel('Time');
%	title(['Subject' num2str(i)]);
%	legend('actual','predicted');
%	saveas(gcf,['../Figures/predicted/all/' num2str(i) '.png']);
	timepoints_grand_actual(i,:)=mean(timepoints_actual);
	timepoints_grand_pred(i,:)=mean(timepoints_pred);
	toc;
end

figure;
plot(timepoints,mean(timepoints_grand_actual),'-',timepoints,mean(timepoints_grand_pred),'-.');
grid on;
ylim([-1 1]);
xlabel('Time');
ylabel('Potential');
title('Grand Average');
legend('actual','predicted');
saveas(gcf,'../Figures/grand_avg.png');

%
%%load(['..', filesep, 'DerivedData', filesep, 'prep_code_variables']);
%load('../Predictors/Alexnet_predictors','predictor5');
%numtimepoints=150;
%numelectrodes=30;
%numsubjects=32;
%%numscenes=50;
%train_ratio=0.8;
%valid_ratio=0.1;
%test_ratio=0.1;
%lambda = 1e-3;
%e_list=[38, 6, 5, 20, 53, 35, 33, 48, 50, 4, 3, 2, 18, 19, 44, 28, 1, 17, 42, 40, 57, 54, 10, 8, 7, 21, 23, 13, 25, 16];
%
%
%for i=1:numsubjects
%	%convert cell arrays to matrix after concatenating all the trials
%	subject_all_trials=cell2mat(permute([subjectdata{i,:}],[1,3,2]));
%
%	%modification added to remove some timepoints and electrodes.
%	subject_all_trials=subject_all_trials(e_list,[101:125,126:3:end],:);
%
%	%generate input; for a single subject this input will not change across electrodes and timepoint
%	temp_input=[];
%	for j=1:numscenes
%		subject_num_trials=size(subjectdata{i,j},2);
%		temp_input=[temp_input;repmat(predictor5(j,:),subject_num_trials,1)]; 
%	end
%
%	tic;
%	parfor j=1:numelectrodes
%		for k=1:numtimepoints
%			data=[squeeze(subject_all_trials(j,k,:)) temp_input];
%			parsave(sprintf(['..', filesep, 'DerivedData', filesep, 'model_data_5', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], i,j,k), data);
%		end
%	end
%	toc;
%
%end

%opt_lambda=zeros(numsubjects,numelectrodes,numtimepoints);
%test_data_idx=cell(numsubjects,numelectrodes,numtimepoints);
%final_ridge=cell(numsubjects,numelectrodes,numtimepoints);
%final_corr=zeros(numsubjects,numelectrodes,numtimepoints);
%
%for i=1:1
%	tic;
%	for j=1:1
%		parfor k=1:5
%			
%			file=parload(sprintf(['..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], i,j,k));
%			cv = cvpartition(size(file.data,1),'HoldOut',test_ratio);
%			test_data_idx{i,j,k}=cv.test;
%			test_data= file.data(cv.test,:);
%			rem_data= file.data(~cv.test,:);
%			%corr_values=[];
%			%for iter=1:1
%			%	corr_values=[corr_values perform_ridge(rem_data,train_ratio,valid_ratio,lambda)];
%			%end
%			[val,idx]=max(perform_ridge(rem_data,train_ratio,valid_ratio,lambda));
%			opt_lambda(i,j,k)=lambda(idx);
%			final_ridge{i,j,k}=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda(i,j,k),0);
%			%apply to test dataset and get correlation
%			final_corr(i,j,k)=corr(final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end),test_data(:,1));
%			
%		end
%	end
%	toc;
%end
%
%save(['..', filesep, 'DerivedData', filesep, 'after_ridge_5_no_iter'],'test_data_idx','final_ridge','final_corr','opt_lambda');



%
%
%
%
%
%
%
%%cv = cvpartition(size(data,1),'HoldOut',0.1);
%%rem_data= data(~cv.test,:);
%%cv = cvpartition(size(rem_data,1),'HoldOut',0.1*(0.8+0.1));
%%train_set=rem_data(~cv.test,:);
%%
%%k = 0.4e-3:1e-5:5e-3;
%%B = ridge(train_set(:,1),train_set(:,2:end),k);
%%plot(k,B,'LineWidth',2);
%%ylim([-100 100])
%%grid on;
%%xticks(linspace(0,1e-3,11));
%%xlabel('Ridge Parameter');
%%ylabel('Standardized Coefficient');
%%saveas(gcf,'../Figures/Ridge.png');
%
%

