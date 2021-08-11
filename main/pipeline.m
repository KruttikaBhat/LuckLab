clear;

%get any required variables; modify if required

subjects=[1:32];
numscenes=50;
scenes=[1:50];
total_numsubjects=32;
timepoints=[1:3:500];

%IAPs dataset
%subjects=[1:29];
%scenes=[1:44];
%timepoints=[1:3:500];
%total_numsubjects=29;
%numscenes=44;

%teardrop
%subjects=[1:16];
%scenes=[1:10]; %channels
%timepoints=[100:375];
%e_list=[1:27];

%frontal region
%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53];
%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53];

%occipital region
e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
%left=[11,10,9,8,43,12,13,14];
%right=[24,23,22,21,59,26,25,27];

train_ratio=0.6;
valid_ratio=0.2;
test_ratio=0.2;
lambda = [0.5e-3,1e-3,1e-2,1e-1];

addpath('../stock_functions');
addpath('../make_plots/');


%1. Extract raw data to get the subject data. Uncomment if you have the raw data and don't yet have prep_code_variables.mat
%read_filename='../../Data/datafolder';
prep_filename='../../DerivedData/prep_code_variables_filtered';
%First_RSA_prep_code(read_filename,prep_filename,total_numsubjects,numscenes);

%2. After getting prep_code_variables perform grand mean subtraction on all the subjects and concatenate all the trials to get after_grand_mean_subtraction.mat. 
%This contains subject_all_trials and numtrials
%Uncomment if you have prep_code_variables.mat but not after_grand_mean_subtraction.mat
gms_filename='../../DerivedData/without_grand_mean_subtraction_filtered';
grand_mean_subtraction(total_numsubjects,numscenes,prep_filename,gms_filename);

%comment step 1 and 2 before running below steps if you already have after_grand_mean_subtraction.mat

%Uncomment to get Alexnet predictors
%load('../../Predictors/Alexnet_predictors');
%predictors=whos('predictor*');

%random predictors
%predictor=rand(length(scenes),3);

%Saliency or meaning predictors. Modify filename accordingly. To get one of these predictors run Basic_predictor_windower.m. 
%load('../../Predictors/IAPs_Saliency_predictor_64');

%load('../../Predictors/Orientation_Alexnet_fixed');
%predictor=new_predictors{5};

for i=5
%filename='../../DerivedData/after_ridge_teardrop_alexnet_5';

%make the folders to store the model data
parent_folder='../../DerivedData/model_data';

if(~exist(parent_folder))
	mkdir(parent_folder);
	for j=1:length(subjects)
		mkdir([parent_folder,sprintf('/Subject_%d',subjects(j))]);
		for k=1:length(e_list)
			mkdir([parent_folder,sprintf('/Subject_%d/Electrode_%d',subjects(j),e_list(k))]);
		end
	end
end

%3. Get the data for each model and store in separate mat files

%specifically for Alexnet predictors. uncomment if you are loading the Alexnet predictors
%get_model_data(eval(predictors(i).name),e_list,subjects,scenes,timepoints,gms_filename,parent_folder);

%for all other predictors
%get_model_data(predictor,e_list,subjects,scenes,timepoints,gms_filename,parent_folder);

%4. Generate the models from the datasets.
%generate_models_each_scene(subjects,e_list,timepoints,train_ratio,valid_ratio,test_ratio,lambda, filename,scenes,gms_filename,parent_folder);
%generate_models_separate_scene(subjects,e_list,timepoints,train_ratio,valid_ratio,test_ratio,lambda,filename,numscenes,gms_filename,parent_folder);

%To get p values for the models. Uncomment only if you want the p values.
%label_permutation_test(subjects,e_list,timepoints,numscenes,filename);
%get_pvalues(subjects,e_list,timepoints,numscenes,filename);

end



