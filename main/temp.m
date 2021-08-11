%subjects=[1:32];
%numscenes=50;
%scenes=[1:50];
%total_numsubjects=32;
%timepoints=[1:3:500];
%
%%frontal region
%%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53];
%%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53];
%
%%occipital region
%e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
%left=[11,10,9,8,43,12,13,14];
%right=[24,23,22,21,59,26,25,27];
%
%train_ratio=0.6;
%valid_ratio=0.2;
%test_ratio=0.2;
%lambda = [0.5e-3,1e-3,1e-2,1e-1];
%
%load('../../DerivedData/after_ridge_Saliency_64_622_filtered_all_subjects');
%
%i=1;
%j=1;
%p=1;
%
%load('../../DerivedData/model_data/Subject_1/Electrode_8/Timepoint_1');
%X=data(:,2:end);
%Y=data(:,1);
%Md1=fitrlinear(X,Y,'Regularization','ridge','CrossVal','on','KFold',5);
%model_corr=corr(Y,kfoldPredict(Md1));
%all_betas=[];
%for i=1:5
%	all_betas=[all_betas; Md1.Trained{i}.Beta'];
%end
%avg_betas=mean(all_betas);
%

%for k=1:numel(timepoints)
%	tic;
%	file=parload(sprintf(['../../DerivedData/model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
%	train_data=[];
%	valid_data=[];
%	test_data=[];
%	for p=1:length(scenes)
%		train_data=[train_data; file.data(data_idx{3,i,p},:)];
%		valid_data=[valid_data; file.data(data_idx{2,i,p},:)];
%		test_data=[test_data; file.data(data_idx{1,i,p},:)];
%	end
%	rem_data=[train_data;valid_data];
%	Md1=fitrlinear(rem_data(:,2:end),rem_data(:,1),'Learner','leastsquares','Regularization','ridge');
%	%coef=ridge(rem_data(:,1),rem_data(:,2:end),opt_lambda(i,j,k),0);
%	p=1;
%	rem_data_test=[file.data(data_idx{3,i,p},1);file.data(data_idx{2,i,p},1)];
%	train_mean(1,k)=mean(rem_data_test);
%	test_data=file.data(data_idx{1,i,p},:);
%	actual(1,k)=mean(test_data(:,1));
%	pred(1,k)=mean(Md1.Bias+test_data(:,2:end)*Md1.Beta);
%	%pred(1,k)=mean(coef(1)+test_data(:,2:end)*coef(2:end));
%	toc;
%	disp(k);
%end	
%
%
%figure;
%plot(timepoints,train_mean,'Color','b','LineStyle','--');
%hold on;
%plot(timepoints,pred,'Color','r','LineStyle','-.');
%hold on;
%plot(timepoints,actual,'g');
%hold off;
%title('Comparison of train mean, test mean and predicted value');
%xlabel('Time');
%ylabel('Potential');
%legend('train mean','predicted','actual');
%grid on;
%saveas(gcf,'../../Figures/sub1_elec8_scene1_saliency_64.jpg')
%

%scenes=[1:50];
%subjects=[1:32];
%numscenes=50;
%scenes=[1:50];
%total_numsubjects=32;
%timepoints=[1:3:500];
%
%%e_list=[1,3,4,6,17,18,19,20,28,29,30,31,33,34,35,36,37,38,44,45,46,47,48,49,50,51,52,53,];
%%left=[1,3,4,6,28,29,30,31,33,34,35,36,37,38];
%%right=[17,18,19,20,44,45,46,47,48,49,50,51,52,53,];
%
%%occipital region
%e_list=[8,9,10,11,12,13,14,21,22,23,24,25,26,27,43,59];
%left=[11,10,9,8,43,12,13,14];
%right=[24,23,22,21,59,26,25,27];
%
%load('../../DerivedData/after_ridge_Saliency_64_622_filtered_all_subjects');
%
%i=1;
%j=1;
%p=1;
%
%train_mean=zeros(1,length(timepoints));
%pred=zeros(1,length(timepoints));
%actual=zeros(1,length(timepoints));
%
%for k=1:length(timepoints)
%	file=parload(sprintf(['../../DerivedData/model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
%	rem_data=[file.data(data_idx{3,i,p},1);file.data(data_idx{2,i,p},1)];
%	train_mean(1,k)=mean(rem_data);
%	test_data=file.data(data_idx{1,i,p},:);
%	actual(1,k)=mean(test_data(:,1));
%        pred(1,k)=mean(final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end));
%end
%
%figure;
%plot(timepoints,train_mean,'Color','b','LineStyle','--');
%hold on;
%plot(timepoints,pred,'Color','y','LineStyle','-.');
%hold on;
%plot(timepoints,actual,'g');
%hold off;
%title('Comparison of train mean, test mean and predicted value');
%xlabel('Time');
%ylabel('Potential');
%legend('train mean','predicted','actual');
%grid on;
%saveas(gcf,'../../Figures/sub1_elec8_scene1_saliency_64.jpg')
%

i=20;
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];

[tf,left_idx]=ismember(left,e_list);
[tf,right_idx]=ismember(right,e_list);

timepoints=[1:3:500];

load('../../DerivedData/iaps_after_grand_mean_subtraction','numtrials');

left_side=zeros(length(left),length(timepoints),length(numtrials{i}));

for j=1:length(left_idx)
	tic;
	for k=1:length(timepoints)
		file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], i,left(j),timepoints(k)));
		left_side(j,k,:)=file.data(:,1);
	end
	toc;
end

right_side=zeros(length(right),length(timepoints),length(numtrials{i}));

for j=1:length(right_idx)
	tic;
	for k=1:length(timepoints)
		file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], i,right(j),timepoints(k)));
		right_side(j,k,:)=file.data(:,1);
	end
	toc;
end

to_plot=zeros(1,length(timepoints));
to_std=zeros(1,length(timepoints));

for i=1:length(timepoints)
	avg_corr=[];
	for j=1:length(left)
		avg_corr=[avg_corr; corr(squeeze(left_side(j,i,:)),squeeze(right_side(j,i,:)))];
	end
	to_plot(1,i)=mean(avg_corr);
	to_std(1,i)=std(avg_corr);
end


x=[timepoints,fliplr(timepoints)];
y=[to_plot+to_std,fliplr(to_plot-to_std)];
fill(x,y,[0.9 0.9 0.9],'LineStyle','none');
hold on;
plot(timepoints,to_plot);
hold off;
xlabel('Time');
ylabel('Avg correlation between left and right electrodes');
grid on;

saveas(gcf,'../../Figures/iaps_left_right_corr.jpg');

