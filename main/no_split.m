function no_split(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit,locationindex,sceneindex)

load(gms_filename,'numtrials');
filename=['../../DerivedData/after_linear_nosplit',end_bit];

betas=zeros(length(subjects),numpixels,length(timepoints),length(e_list));
final_corr=zeros(length(subjects),numpixels,length(timepoints));
stacked_corr=zeros(length(subjects),length(timepoints));

for i=1:length(subjects)
	tic;
	%split such that some trials from each scene go into the test dataset
	load(sprintf([parent_folder,filesep,'Subject_%d.mat'],subjects(i)),'model_data');
	parfor k=1:length(timepoints)
		stacked_data=[];
                pred_data=[];
		for j=1:numpixels
			y=model_data{j,k}(:,1);
			X=model_data{j,k}(:,2:end);

			b=regress(y,X);
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

save(filename,'betas','final_corr','stacked_corr','scenes','locationindex','sceneindex');

end
