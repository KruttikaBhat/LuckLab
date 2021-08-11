function get_model_data_v2(output,e_list,subjects,scenes,timepoints,numpixels,gms_filename,parent_folder)

load(gms_filename);

for i=1:length(subjects)
	tic;
	model_data=cell(size(output,2),length(timepoints));
	for j=1:numpixels
		temp_output=[];
		for k=1:length(scenes)
			%temp_output=[temp_output;repmat(output(scenes(k),j),sum(numtrials{subjects(i)}==scenes(k)),1)]; %no averaging
			if sum(numtrials{subjects(i)}==scenes(k))~=0 %for averaging trials
				temp_output=[temp_output; output(scenes(k),j)];
			end
		end
		temp_input=zeros(length(e_list),length(timepoints),length(temp_output));
		count=0;
		for p=1:length(scenes)
			scene_num_trials=length(find(numtrials{subjects(i)}==scenes(p)));
			if scene_num_trials~=0
				%temp_input(:,:,count+1:count+scene_num_trials)=subject_all_trials{subjects(i)}(e_list,timepoints,find(numtrials{subjects(i)}==scenes(p)));
				%count=count+scene_num_trials;
				temp_input(:,:,count+1)=mean(subject_all_trials{subjects(i)}(e_list,timepoints,find(numtrials{subjects(i)}==scenes(p))),3);
				count=count+1;
			end
		end
		parfor k=1:length(timepoints)
			X=squeeze(temp_input(:,k,:))';
			%X=rand(length(temp_output),length(e_list));
			%order=randperm(length(temp_output));
			%re_ordered_output=temp_output(order);
			%for p=1:size(X,2)
			%	order=randperm(size(X,1));
			%	re_ordered_X(:,p)=X(order,p);
			%end
			data=[temp_output X];
			data=(data-mean(data))./std(data);
			model_data{j,k}=data;
		end
		
	end
	save(sprintf([parent_folder,filesep,'Subject_%d.mat'],subjects(i)),'model_data','-v7.3');
	toc;
	disp(i);
end

end


%method for pca, not used but here if required
%coeff=copied_pca(X);
%nu_coeff=rotatefactors(coeff,'Method','varimax');
%nu_score=X*nu_coeff;
%re_ordered_X=zeros(size(X));
