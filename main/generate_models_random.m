function generate_models_random(subjects,e_list,timepoints,train_ratio,valid_ratio,test_ratio,lambda,filename,numscenes)

load('../../DerivedData/after_grand_mean_subtraction_mini_avg','numtrials');

opt_lambda=zeros(length(subjects),length(e_list),length(timepoints));
test_data_idx=cell(length(subjects),length(e_list),length(timepoints));
final_ridge=cell(length(subjects),length(e_list),length(timepoints));
final_corr=zeros(length(subjects),length(e_list),length(timepoints));
%num_test_scenes=round(numscenes*test_ratio);
%num_valid_scenes=round(numscenes*valid_ratio);

for i=1:length(subjects)
	tic;
	for j=1:length(e_list)
		parfor k=1:numel(timepoints)
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			%random split
			cv = cvpartition(size(file.data,1),'HoldOut',test_ratio);
			test_data_idx{i,j,k}=cv.test;
			test_data= file.data(cv.test,:);
			rem_data= file.data(~cv.test,:);
			%corr_values=[];
			%for iter=1:15
			%	corr_values=[corr_values perform_ridge(rem_data,train_ratio,valid_ratio,lambda)];
			%end
			%[val,idx]=max(mean(corr_values,2));
			[val,idx]=max(perform_ridge(rem_data,lambda,valid_start_idx));
			opt_lambda(i,j,k)=lambda(idx);
			final_ridge{i,j,k}=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda(i,j,k),0);
			%apply to test dataset and get correlation
			final_corr(i,j,k)=corr(final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end),test_data(:,1));
		end
	end
	toc;
end

save(['..', filesep,'..', filesep, 'DerivedData', filesep, filename],'test_data_idx','final_ridge','final_corr','opt_lambda');

end
%
%function values=perform_ridge(data,lambda,valid_start_idx)
%
%cv = cvpartition(size(data,1),'HoldOut',valid_ratio*(train_ratio+valid_ratio));
%train_set=data(~cv.test,:);
%valid_set=data(cv.test,:);
%
%%when making predictions, scaling flag should be set to 0; the default value is 1.
%ridge_coefficients = ridge(train_set(:,1),train_set(:,2:end),lambda,0);
%
%%check accuracy using validation set
%yhat = ridge_coefficients(1,:) + valid_set(:,2:end)*ridge_coefficients(2:end,:);
%values=corr(yhat,valid_set(:,1));
%
%end
