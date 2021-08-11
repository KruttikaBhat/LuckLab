function grand_mean_subtraction_mini_average(total_numsubjects,numscenes)
load(['..', filesep, '..', filesep, 'DerivedData', filesep, 'prep_code_variables_filtered']);

numtrials={};
subject_all_trials={};
for i=1:total_numsubjects
	tic;
	%convert cell arrays to 3D matrix after concatenating all the trials
	subject_all_trials{i}=cell2mat(permute([subjectdata{i,:}],[1,3,2]));

	%perform grand mean subtraction
	for j=1:size(subject_all_trials{i},3)
		subject_all_trials{i}(:,:,j)=subject_all_trials{i}(:,:,j)-mean(subject_all_trials{i},3);
	end
	
	%store number of trials for later plots
	%perform mini average on trials
	temp_trial_num=[];
	temp_all_trials=[];
	count=0;
	for j=1:numscenes
		rand_seq=randperm(size(subjectdata{i,j},2));
		for k=1:2:length(rand_seq)
			if k~=length(rand_seq)
				pair=cat(3,subject_all_trials{i}(:,:,count+rand_seq(k)),subject_all_trials{i}(:,:,count+rand_seq(k+1)));
				temp_all_trials=cat(3, temp_all_trials, mean(pair,3));
			else
				temp_all_trials=cat(3, temp_all_trials, subject_all_trials{i}(:,:,count+rand_seq(k)));
			end
		end
		count=count+length(rand_seq);
		temp_trial_num=[temp_trial_num repmat(j,1,round(length(rand_seq)/2))];
	end
	subject_all_trials{i}=temp_all_trials;
	numtrials{i}=temp_trial_num;
	toc;
	

end

save('../../DerivedData/after_grand_mean_subtraction_filtered_mini_avg','numtrials','subject_all_trials','-v7.3');

end
