
clear;

%get any required variables; modify if required

subjects=[5,12,16,20,24,29];
numscenes=50;
total_numsubjects=32;
timepoints=[1:3:500];
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];

lambda = [0.5e-3,1e-3,1e-2,1e-1];

addpath('../stock_functions');
addpath('../make_plots/');

filename='Alexnet_5_333_filtered';

load(['..', filesep,'..', filesep, 'DerivedData', filesep, 'after_ridge_', filename],'data_idx','final_corr');

all_corr=zeros(3,length(subjects),length(e_list),length(timepoints));
all_corr(1,:,:,:)=final_corr;

%round 2
for i=1:length(subjects)
tic;
	for j=1:length(e_list)
		for k=1:numel(timepoints)
			tic;
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			train_data=[];
			valid_data=[];
			test_data=[];
			for p=1:numscenes
				train_data=[train_data; file.data(data_idx{1,i,p},:)];
				valid_data=[valid_data; file.data(data_idx{3,i,p},:)];
				test_data=[test_data; file.data(data_idx{2,i,p},:)];
			end
			[val,idx]=max(perform_ridge(train_data,valid_data,lambda,numscenes));
			opt_lambda=lambda(idx);
			rem_data=[train_data;valid_data];
			final_ridge=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda,0);
			all_corr(2,i,j,k)=corr(test_data(:,1),final_ridge(1)+test_data(:,2:end)*final_ridge(2:end));

		end
	end
toc;
end


%round 3
for i=1:length(subjects)
tic;
	for j=1:length(e_list)
		parfor k=1:numel(timepoints)
			tic;
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			train_data=[];
			valid_data=[];
			test_data=[];
			for p=1:numscenes
				train_data=[train_data; file.data(data_idx{2,i,p},:)];
				valid_data=[valid_data; file.data(data_idx{1,i,p},:)];
				test_data=[test_data; file.data(data_idx{3,i,p},:)];
			end
			[val,idx]=max(perform_ridge(train_data,valid_data,lambda,numscenes));
			opt_lambda=lambda(idx);
			rem_data=[train_data;valid_data];
			final_ridge=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda,0);
			all_corr(3,i,j,k)=corr(test_data(:,1),final_ridge(1)+test_data(:,2:end)*final_ridge(2:end));

		end
	end
toc;
end

save(['..', filesep,'..', filesep, 'DerivedData', filesep, 'after_ridge_multiple_', filename],'all_corr');




function values=perform_ridge(train_data,valid_data,lambda,numscenes)

%when making predictions, scaling flag should be set to 0; the default value is 1.
ridge_coefficients = ridge(train_data(:,1),train_data(:,2:end),lambda,0);

%check accuracy using validation set
yhat = ridge_coefficients(1,:) + valid_data(:,2:end)*ridge_coefficients(2:end,:);
values=corr(yhat,valid_data(:,1));

end

