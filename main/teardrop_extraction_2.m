mydir='../../Data/Exp2_Data/';
files=dir([mydir,'*.mat']);

subject_all_trials={};
numtrials={};

for i=1:length(files)
	base=files(i).name;
	load([mydir,base]);
	[trials,electrodes,timepoints]=size(data.eeg);
	subject_mean=squeeze(mean(data.eeg,1));
	subject_all_trials{i}=zeros(electrodes,timepoints,trials);
	for j=1:trials
		subject_all_trials{i}(:,:,j)=squeeze(data.eeg(j,:,:))-subject_mean;
	end
	numtrials{i}=zeros(1,length(data.targetLocBin));
	scene=1;
	for j=1:16
		location=find(data.targetLocBin==j); %flipped one
		%orientation=find(data.targetOriBin==j); %correct one
		for k=1:16
			orientation=find(data.targetOriBin==k); %flipped one
			%location=find(data.targetLocBin==k); %correct one
			index=intersect(orientation,location);
			numtrials{i}(1,index)=scene;
			scene=scene+1;
		end
	end
	disp(i);
end

save('../../DerivedData/after_grand_mean_subtraction_teardrop_2_flipped','numtrials','subject_all_trials','-v7.3');
