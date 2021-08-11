clear;

%subjects=[1:32];
%numscenes=50;
%scenes=[1:50];
%total_numsubjects=32;
%timepoints=[1:3:500];

%subjects=[1:16];
%scenes=[1:10];
%timepoints=[100:375];
%e_list=[1:27];

subjects=[1:29];
scenes=[1:44];
timepoints=[1:3:500];

%frontal region
%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53];
%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53];

%occipital region
e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];

addpath('../stock_functions');
addpath('../make_plots/');

parent_folder='../../DerivedData/model_data';
gms_filename='../../DerivedData/iaps_after_grand_mean_subtraction';


load(gms_filename,'numtrials');

predictor=rand(length(scenes),192);
%load('../../Predictors/IAPs_Saliency_predictor_64');
%load('../../Predictors/Orientation_Alexnet_fixed');
%predictor=new_predictors{3};

get_model_data(predictor,e_list,subjects,scenes,timepoints,gms_filename,parent_folder);

final_corr=zeros(length(subjects),length(e_list),length(timepoints));
avg_betas=zeros(length(subjects),length(e_list),length(timepoints),size(predictor,2));
filename='../../DerivedData/after_fitrlinear_iaps_random_192';

for i=1:length(subjects)
	tic;
	for j=1:length(e_list)
		parfor k=1:length(timepoints)
			file=parload(sprintf(['../../DerivedData/model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			count=0;
			%all trials avg
%			avg_data=zeros(50,size(file.data,2));
%			for p=1:length(scenes)
%				scene_trials=length(find(numtrials{subjects(i)}==scenes(p)));
%				avg_data(p,:)=mean(file.data(count+1:count+scene_trials,:));
%				count=count+scene_trials;
%			end
			%some trial avg
%			cluster=5;
%			avg_data=[];
%			for p=1:length(scenes)
%				scene_trials=length(find(numtrials{subjects(i)}==scenes(p)));
%				subcount=count;
%				for c=1:floor(scene_trials/cluster)
%					avg_data=[avg_data; mean(file.data(subcount+1:subcount+cluster,:))];
%					subcount=subcount+cluster;
%				end
%				if subcount~=count+scene_trials
%					if count+scene_trials-subcount==1
%						avg_data=[avg_data; file.data(subcount+1,:)];
%					else
%						avg_data=[avg_data; mean(file.data(subcount+1:count+scene_trials,:))];
%					end
%				end
%				count=count+scene_trials;
%			end
			X=file.data(:,2:end);
			Y=file.data(:,1);
			Md1=fitrlinear(X,Y,'Regularization','ridge','CrossVal','on','KFold',5);
			final_corr(i,j,k)=corr(Y,kfoldPredict(Md1));
			all_betas=[];
			for p=1:5
				all_betas=[all_betas; Md1.Trained{p}.Beta'];
			end
			avg_betas(i,j,k,:)=mean(all_betas);
		end
	end
	toc;
	disp(i);
end

save(filename,'avg_betas','final_corr');

