function generate_models_each_scene(subjects,e_list,timepoints,train_ratio,valid_ratio,test_ratio,lambda,filename,scenes,gms_filename,parent_folder)

load(gms_filename,'numtrials');

opt_lambda=zeros(length(subjects),length(e_list),length(timepoints));
data_idx=cell(3,length(subjects),length(scenes));
final_ridge=cell(length(subjects),length(e_list),length(timepoints));
final_corr=zeros(length(subjects),length(e_list),length(timepoints));

for i=1:length(subjects)
	tic;
	%split such that some trials from each scene go into the test dataset
	count=0;
	for p=1:length(scenes)
		scene_num_trials=length(find(numtrials{subjects(i)}==scenes(p)));
		random_trials=randperm(scene_num_trials)+count;
		te_lim=round(scene_num_trials*test_ratio);
		va_lim=te_lim+round(scene_num_trials*valid_ratio);
		%testing set
		data_idx{1,i,p}=random_trials(1:te_lim);
		%validation set
		data_idx{2,i,p}=random_trials(te_lim+1:va_lim);
		%training set
		data_idx{3,i,p}=random_trials(va_lim+1:end);
		count=count+scene_num_trials;
	end
	for j=1:length(e_list)
		parfor k=1:numel(timepoints)
			file=parload(sprintf([parent_folder, filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			train_data=[];
			valid_data=[];
			test_data=[];
			for p=1:length(scenes)
				train_data=[train_data; file.data(data_idx{3,i,p},:)];
				valid_data=[valid_data; file.data(data_idx{2,i,p},:)];
				test_data=[test_data; file.data(data_idx{1,i,p},:)];
			end
			[val,idx]=max(perform_ridge(train_data,valid_data,lambda));
			opt_lambda(i,j,k)=lambda(idx);
			rem_data=[train_data;valid_data];
			final_ridge{i,j,k}=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda(i,j,k),0);
			final_corr(i,j,k)=corr(test_data(:,1),final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end));
		end
	end
	toc;
	disp(i);
end

save(filename,'data_idx','final_corr','final_ridge','opt_lambda');

end


function values=perform_ridge(train_data,valid_data,lambda)

%when making predictions, scaling flag should be set to 0; the default value is 1.
ridge_coefficients = ridge(train_data(:,1),train_data(:,2:end),lambda,0);

%check accuracy using validation set
yhat = ridge_coefficients(1,:) + valid_data(:,2:end)*ridge_coefficients(2:end,:);
values=corr(yhat,valid_data(:,1));

end

