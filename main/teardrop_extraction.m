
mydir='../../Data/Exp1_Data/';
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
	numtrials{i}=data.channel;
	disp(i);
end

save('../../DerivedData/after_grand_mean_subtraction_teardrop','numtrials','subject_all_trials','-v7.3');
