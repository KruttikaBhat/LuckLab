clear;

subjects=[1:16];
scenes=[1:256]; %channels
timepoints=[1:3:750];
%scenes=randperm(256,128);

%right=1, left=0
load('../../Predictors/location_index.mat');
%scenes=find(locationindex==0);
%selected=scenes(randperm(numel(scenes),32));
%scenes=selected;

left=[1,3,4,6,8,9,10,11,12,13,14];
right=[17:27];

%frontal=[1,2,3,4,17,18,19];
%occipital=[8,9,10,11,12,13,14,21,22,23,24,25,26,27];

e_list=[left right];

%subjects=[1:10];
%scenes=[1:50];
%timepoints=[1:3:500];
%e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53];

addpath('../stock_functions');
addpath('../make_plots/');

gms_filename='../../DerivedData/after_grand_mean_subtraction_teardrop_2';

load('../../Predictors/Teardrop_Study2_fixed');
predictor=new_predictors{3};

numpixels=size(predictor,2);

parent_folder='../../DerivedData/model_data';
%filename='../../DerivedData/after_linear_nosplit_teardrop_2_rightscenes_alexnet_3_occipital_allsubjects_128scenes.mat';


%normal output

%end_bit='_teardrop_2_averagetrials_alexnet_3_leftright_allsubjects_256scenes.mat';

%get_model_data_v2(predictor,e_list,subjects,scenes,timepoints,numpixels,gms_filename,parent_folder);

%no_split(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit);
%within_scene(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit);
%scenewise(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit);

%random shuffled output

%rand_predictor=zeros(size(predictor,1),size(predictor,2));
%for i=1:length(scenes)
%        order=randperm(size(predictor,2));
%	rand_predictor(scenes(i),:)=predictor(scenes(i),order);
%end

%end_bit='_teardrop_2_averagetrials_alexnet_3_shuffled_leftright_allsubjects_256scenes.mat';

%get_model_data_v2(rand_predictor,e_list,subjects,scenes,timepoints,numpixels,gms_filename,parent_folder);

%no_split(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit);
%within_scene(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit);
%scenewise(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit);

%left right encoded output

end_bit='_teardrop_2_leftrightsplitencode_leftright_allsubjects_256scenes.mat';

%locationindex=zeros(1,256);
%locationindex(1,randperm(256,128))=1;

get_model_data_encodedoutput(predictor,e_list,subjects,scenes,timepoints,numpixels,gms_filename,parent_folder,locationindex,sceneindex);

no_split(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit,locationindex,sceneindex);
within_scene(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit,locationindex,sceneindex);
scenewise(subjects,e_list,timepoints,numpixels,scenes,gms_filename,parent_folder,end_bit,locationindex,sceneindex);


%numpixels=size(predictor,2);

%parent_folder='../../DerivedData/model_data';
%filename='../../DerivedData/after_linear_within_scene_teardrop_2_alexnet_3_shuffled_occipital_3subjects_256scenes';
%
%get_model_data_v2(rand_predictor,e_list,subjects,scenes,timepoints,numpixels,gms_filename,parent_folder,locationindex);

%generate_models_each_scene_v2(subjects,e_list,timepoints,numpixels,filename,scenes,gms_filename,parent_folder,locationindex);


%for i=1:length(scenes)
%	min_value=min(predictor(scenes(i),:)');
%	max_value=max(predictor(scenes(i),:)');
%	rand_predictor(i,:)=(max_value-min_value).*rand(1,size(predictor,2))+min_value;	
%end

%numpixels=size(predictor,2);

%parent_folder='../../DerivedData/model_data';
%filename='../../DerivedData/after_linear_nosplit_rsa_averagetrials_random_output_occipital_allsubjects';

%get_model_data_v2(rand_predictor,e_list,subjects,scenes,timepoints,numpixels,gms_filename,parent_folder,locationindex);

%generate_models_each_scene_v2(subjects,e_list,timepoints,numpixels,filename,scenes,gms_filename,parent_folder,locationindex);


