function generate_models_separate_scene(subjects,e_list,timepoints,train_ratio,valid_ratio,test_ratio,lambda,filename,numscenes,gms_filename,parent_folder)

load(gms_filename,'numtrials');

opt_lambda=zeros(length(subjects),length(e_list),length(timepoints));
data_idx=zeros(1,length(subjects));
final_ridge=cell(length(subjects),length(e_list),length(timepoints));
final_corr=zeros(length(subjects),length(e_list),length(timepoints));
num_test_scenes=round(numscenes*test_ratio);
num_valid_scenes=round(numscenes*valid_ratio);

for i=1:length(subjects)
	tic;
	[tf,test_start_idx]=ismember(numscenes-num_test_scenes+1,numtrials{subjects(i)});
	[tf,valid_start_idx]=ismember(numscenes-num_test_scenes-num_valid_scenes+1,numtrials{subjects(i)});
	data_idx(1,i)=test_start_idx;
	for j=1:length(e_list)
		parfor k=1:numel(timepoints)
			file=parload(sprintf([parent_folder, filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			%split based on scenes, keep those scenes completely separate
			test_data=file.data(test_start_idx:end,:);
			rem_data=file.data(1:test_start_idx-1,:);
			[val,idx]=max(perform_ridge(rem_data,lambda,valid_start_idx));
			opt_lambda(i,j,k)=lambda(idx);
			final_ridge{i,j,k}=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda(i,j,k),0);
			%apply to test dataset and get correlation
			final_corr(i,j,k)=corr(final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end),test_data(:,1));
		end
	end
	toc;
end

save(filename,'data_idx','final_ridge','final_corr','opt_lambda');

end

function values=perform_ridge(data,lambda,valid_start_idx)

train_set=data(1:valid_start_idx-1,:);
valid_set=data(valid_start_idx:end,:);

%when making predictions, scaling flag should be set to 0; the default value is 1.
ridge_coefficients = ridge(train_set(:,1),train_set(:,2:end),lambda,0);

%check accuracy using validation set
yhat = ridge_coefficients(1,:) + valid_set(:,2:end)*ridge_coefficients(2:end,:);
values=corr(yhat,valid_set(:,1));

end



