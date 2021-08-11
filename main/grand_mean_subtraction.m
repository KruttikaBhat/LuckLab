function grand_mean_subtraction(total_numsubjects,numscenes,prep_filename,gms_filename)
load(prep_filename);

numtrials={};
subject_all_trials={};
for i=1:total_numsubjects
	tic;
	%convert cell arrays to 3D matrix after concatenating all the trials
	subject_all_trials{i}=cell2mat(permute([subjectdata{i,:}],[1,3,2]));

	%perform grand mean subtraction
	subject_mean=mean(subject_all_trials{i},3);
	for j=1:size(subject_all_trials{i},3)
		subject_all_trials{i}(:,:,j)=subject_all_trials{i}(:,:,j)-subject_mean;
	end
	
	%store number of trials for later plots
	temp_trials=[];
	for j=1:numscenes
		temp_trials=[temp_trials repmat(j,1,size(subjectdata{i,j},2))];
	end
	numtrials{i}=temp_trials;
	toc;
	

end

save(gms_filename,'numtrials','subject_all_trials','-v7.3');

end
