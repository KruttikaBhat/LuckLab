function within_scene(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit,locationindex,sceneindex)

load(gms_filename,'numtrials');
filename=['../../DerivedData/after_linear_within_scene',end_bit];

data_idx=cell(2,length(subjects),length(scenes));
betas=zeros(length(subjects),numpixels,length(timepoints),length(e_list));
final_corr=zeros(length(subjects),numpixels,length(timepoints));
test_ratio=0.2;
stacked_corr=zeros(length(subjects),length(timepoints));

for i=1:length(subjects)
	tic;
	%split such that some trials from each scene go into the test dataset
	count=0;
	for p=1:length(scenes)
		scene_num_trials=length(find(numtrials{subjects(i)}==scenes(p)));
		random_trials=randperm(scene_num_trials)+count;
		te_lim=round(scene_num_trials*test_ratio);
		%testing set
		data_idx{1,i,p}=random_trials(1:te_lim);
		%training set
		data_idx{2,i,p}=random_trials(te_lim+1:end);
		count=count+scene_num_trials;
	end
	load(sprintf([parent_folder,filesep,'Subject_%d.mat'],subjects(i)),'model_data');
	parfor k=1:length(timepoints)
		stacked_data=[];
                pred_data=[];
		for j=1:numpixels
			train_data=[];
			test_data=[];
			for p=1:length(scenes)
				train_data=[train_data; model_data{j,k}(data_idx{2,i,p},:)];
				test_data=[test_data; model_data{j,k}(data_idx{1,i,p},:)];
			end
		
			y=train_data(:,1);
			X=train_data(:,2:end);
			
			b=regress(y,X);

			y=test_data(:,1);
			X=test_data(:,2:end);

			pred=X*b;

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

save(filename,'betas','final_corr','stacked_corr','data_idx','scenes','locationindex','sceneindex');

end
