function get_model_data(predictor,e_list,subjects,scenes,timepoints,gms_filename,parent_folder)

load(gms_filename);


for i=1:length(subjects)
	tic;
	%generate input; for a single subject this input will not change across electrodes and timepoint
	temp_input=[];
	for j=1:length(scenes)
		temp_input=[temp_input;repmat(predictor(j,:),sum(numtrials{subjects(i)}==scenes(j)),1)];
	end

	%Gets data for all scenes 
	%current_subject=subject_all_trials{i}; 
	%Gets data for scenes specified by 'scenes' variables
	current_subject=zeros(length(e_list),length(timepoints),size(temp_input,1));
	count=0;
	for j=scenes
		scene_num_trials=length(find(numtrials{subjects(i)}==j));
		current_subject(:,:,count+1:count+scene_num_trials)=subject_all_trials{subjects(i)}(e_list,timepoints,find(numtrials{subjects(i)}==j));
		count=count+scene_num_trials;
	end
	for j=1:length(e_list)
		parfor k=1:length(timepoints)
			%remove some timepoints and electrodes based on e_list and timepoints variables. Also concatenates predictors with output
			data=[squeeze(current_subject(j,k,:)) temp_input];
			%perform standardization such that each column of data will have 0 mean and unit variance
			data=(data-mean(data))./std(data);
			parsave(sprintf([parent_folder, filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)), data);
		end
	end
	toc;

end

end


