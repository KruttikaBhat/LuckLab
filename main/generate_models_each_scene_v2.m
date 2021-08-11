function generate_models_each_scene_v2(subjects,e_list,timepoints,numpixels,filename,scenes,gms_filename,parent_folder,locationindex)

load(gms_filename,'numtrials');

data_idx=cell(length(subjects));
betas=zeros(length(subjects),numpixels,length(timepoints),length(e_list));
final_corr=zeros(length(subjects),numpixels,length(timepoints));
test_ratio=0.2;
stacked_corr=zeros(length(subjects),length(timepoints));

for i=1:length(subjects)
	tic;
	%split such that some trials from each scene go into the test dataset
	count=0;
%	for p=1:length(scenes)
%		scene_num_trials=length(find(numtrials{subjects(i)}==scenes(p)));
%		random_trials=randperm(scene_num_trials)+count;
%		te_lim=round(scene_num_trials*test_ratio);
%		%testing set
%		data_idx{1,i,p}=random_trials(1:te_lim);
%		%training set
%		data_idx{2,i,p}=random_trials(te_lim+1:end);
%		count=count+scene_num_trials;
%	end
%	test_limit=round(length(scenes)*test_ratio); %scenewise, no averaging trials
%	for p=1:test_limit
%		scene_num_trials=length(find(numtrials{subjects(i)}==scenes(p)));
%		count=count+scene_num_trials;
%	end
%	data_idx{i}=count;
	load(sprintf([parent_folder,filesep,'Subject_%d.mat'],subjects(i)),'model_data');
%	random_scenes=randperm(size(model_data{1,1},1)); %scene wise, averaging trials
%	te_lim=round(size(model_data{1,1},1)*test_ratio);
%	data_idx{i}=random_scenes;
	parfor k=1:length(timepoints)
		stacked_data=[];
                pred_data=[];
		for j=1:numpixels
			%train_data=[];
			%test_data=[];
			%for p=1:length(scenes)
			%	train_data=[train_data; model_data{j,k}(data_idx{2,i,p},:)];
			%	test_data=[test_data; model_data{j,k}(data_idx{1,i,p},:)];
			%end
			%test_data=model_data{j,k}(1:count,:);
			%train_data=model_data{j,k}(count+1:end,:);
			%test_data=model_data{j,k}(random_scenes(1:te_lim),:);
			%train_data=model_data{j,k}(random_scenes(te_lim+1:end),:);

			%y=train_data(:,1);
			%X=train_data(:,2:end);
			y=model_data{j,k}(:,1);
			X=model_data{j,k}(:,2:end);

			b=regress(y,X);
			%b=mnrfit(X,y);

			%y=test_data(:,1);
			%X=test_data(:,2:end);

			pred=X*b;
			%pred=b(1)+X*b(2:end);

			%kfold
			%Md1=fitrlinear(X,y,'CrossVal','on','KFold',5);
			%all_betas=[];
                        %for p=1:5
                        %        all_betas=[all_betas; Md1.Trained{p}.Beta'];
                        %end
                        %b=mean(all_betas);
			%pred=kfoldPredict(Md1);

			final_corr(i,j,k)=corr(y,pred);
			betas(i,j,k,:)=b;
			pred_data=[pred_data; pred];
                        stacked_data=[stacked_data; y];

		end
		stacked_corr(i,k)=corr(stacked_data,pred_data);
	end
	toc;
	disp(i);
end

save(filename,'betas','final_corr','stacked_corr');

end
