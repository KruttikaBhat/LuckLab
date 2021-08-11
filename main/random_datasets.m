load('../../DerivedData/after_grand_mean_subtraction_filtered','numtrials');
load('../../Predictors/Alexnet_predictors');

numscenes=50;
timepoints=[1:500];

train_ratio=0.6;
valid_ratio=0.2;
test_ratio=0.2;
lambda = [0.5e-3,1e-3,1e-2,1e-1];

data_idx=cell(3,numscenes);

temp_input=[];
for j=1:numscenes
	temp_input=[temp_input;repmat(predictor5(j,:),sum(numtrials{1}==j),1)];
end
temp_input=(temp_input-mean(temp_input))./std(temp_input);

pred_waveform=zeros(numscenes,length(timepoints));
actual_waveform=zeros(numscenes,length(timepoints));
final_corr=zeros(length(timepoints),1);
final_ridge=zeros(length(timepoints),size(temp_input,2)+1);

square=-1;
column=25;
factor=0.5;
for j=1:length(timepoints)
	current_subject=normrnd(0,1,[length(numtrials{1}),1]);
	data=[current_subject temp_input];
	disp(square)
	if square==1
		data(:,1)=data(:,1)+(temp_input(:,column).*factor);
	end
	if mod(j,50)==0
		disp(j)
		square=square*-1;
	end
	count=0;
	for p=1:numscenes
		scene_num_trials=length(find(numtrials{1}==p));
		random_trials=randperm(scene_num_trials)+count;
		te_lim=round(scene_num_trials*test_ratio);
		va_lim=te_lim+round(scene_num_trials*valid_ratio);
		%testing set
		data_idx{1,p}=random_trials(1:te_lim);
		%validation set
		data_idx{2,p}=random_trials(te_lim+1:va_lim);
		%train set
		data_idx{3,p}=random_trials(va_lim+1:end);
		count=count+scene_num_trials;
	end

	test_data={};
	train_data=[];
	valid_data=[];
	for p=1:numscenes
		train_data=[train_data; data(data_idx{3,p},:)];
		valid_data=[valid_data; data(data_idx{2,p},:)];
		test_data{p}=data(data_idx{1,p},:);
	end

	[val,idx]=max(perform_ridge(train_data,valid_data,lambda,numscenes));
	opt_lambda=lambda(idx);
	rem_data=[train_data;valid_data];
	final_ridge(j,:)=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda,0);
	%apply to test dataset and get correlation
%	pred=zeros(numscenes,1);
%	actual=zeros(numscenes,1);
%	for p=1:numscenes
%		pred(p,1)=mean(final_ridge(1)+test_data{p}(:,2:end)*final_ridge(2:end));
%		actual(p,1)=mean(test_data{p}(:,1));
%	end
%	final_corr(j)=corr(actual(:),pred(:));
%	pred_waveform(:,j)=pred(:);
%	actual_waveform(:,j)=actual(:);

end

for j=1:size(final_ridge,2)
	figure;
	plot(timepoints,final_ridge(:,j)');
	xlabel("Time");
	ylabel("Coefficient value");
	title(['Coefficient ',num2str(j)]);
	saveas(gcf,['../../Figures/waveforms/',num2str(j),'.jpg']);
end

save('../../DerivedData/after_ridge_Alexnet_5_random_datasets','final_ridge');

%for p=1:numscenes
%	t_p=pred_waveform(p,1:100);
%	t_a=actual_waveform(p,1:100);
%	title_name=['Scene-' num2str(p)];
%	filename=['../../Figures/random_waveforms/' title_name '.png'];
%	%plot_waveform(title_name,filename,[1:100],t_a,t_p);
%end
%
%figure;
%hist(final_corr)
%title('Random models correlation')
%saveas(gcf,'../../Figures/random_corr_histogram.png');
%


function values=perform_ridge(train_data,valid_data,lambda,numscenes)

%when making predictions, scaling flag should be set to 0; the default value is 1.
ridge_coefficients = ridge(train_data(:,1),train_data(:,2:end),lambda,0);

%check accuracy using validation set
yhat = ridge_coefficients(1,:) + valid_data(:,2:end)*ridge_coefficients(2:end,:);
values=corr(yhat,valid_data(:,1));

end

function plot_waveform(title_name,filename,x,t_a,t_p)

figure;
plot(x,t_a,'-',x,t_p,'-.');
grid on;
%ylim([-1 1]);
xlabel('Time');
ylabel('Potential');
title(title_name);
legend('actual','predicted');
saveas(gcf,filename);

end
