
[num_meaning,txt,raw] = xlsread('../../Data/occipital_RSA.xlsx','Meaning');
[num_saliency,txt,raw] = xlsread('../../Data/occipital_RSA.xlsx','Saliency');
meaning=load('../../DerivedData/after_ridge_Meaning_64_622_filtered_all_subjects_NCB','final_corr');
saliency=load('../../DerivedData/after_ridge_Saliency_64_622_filtered_all_subjects_NCB','final_corr');
timepoints=[1:3:500];

ridge_stuff_meaning=zeros(size(meaning.final_corr,1),size(meaning.final_corr,3));
ridge_stuff_saliency=zeros(size(saliency.final_corr,1),size(saliency.final_corr,3));
rsa_stuff_meaning=num_meaning(:,timepoints);
rsa_stuff_saliency=num_saliency(:,timepoints);

for i=1:size(meaning.final_corr,1)
	to_plot_meaning=squeeze(meaning.final_corr(i,:,:));
	to_plot_saliency=squeeze(saliency.final_corr(i,:,:));
	ridge_stuff_meaning(i,:)=mean(to_plot_meaning);
	ridge_stuff_saliency(i,:)=mean(to_plot_saliency);
	figure;
	plot(timepoints,ridge_stuff_saliency(i,:),'b',timepoints,ridge_stuff_meaning(i,:),'r');
	hold on;
	x=[timepoints,fliplr(timepoints)];
	y=[mean(to_plot_saliency)+std(to_plot_saliency),fliplr(mean(to_plot_saliency)-std(to_plot_saliency))];
	h=fill(x,y,[0.5 0.5 1],'LineStyle','none');
	set(h,'facealpha',.5);
	hold on;
	y=[mean(to_plot_meaning)+std(to_plot_meaning),fliplr(mean(to_plot_meaning)-std(to_plot_meaning))];
	h=fill(x,y,[1 0.5 0.5],'LineStyle','none');
	set(h,'facealpha',.5)
	hold on; 
	plot(timepoints,ridge_stuff_saliency(i,:),'b',timepoints,ridge_stuff_meaning(i,:),'r');
	hold off;
	xlabel('Time');
	ylabel('Correlation');
	legend('Saliency','Meaning');
	title(['Subject ' num2str(i)]);
	ylim([-0.2,0.6]);
	grid on;
	saveas(gcf,['../../Figures/RR/Subject_' num2str(i) '.jpg']);
	
	figure;
	plot(timepoints,rsa_stuff_saliency(i,:),'b',timepoints,rsa_stuff_meaning(i,:),'r');
	xlabel('Time');
	ylabel('Correlation');
	legend('Saliency','Meaning');
	title(['Subject ' num2str(i)]);
	ylim([-0.2,0.6]);
	grid on;
	saveas(gcf,['../../Figures/RSA/Subject_' num2str(i) '.jpg']);

end




%subject_corr=zeros(1,size(ridge_stuff,1));
%for i=1:size(ridge_stuff,1)
%	subject_corr(1,i)=corr(rsa_stuff(i,:)',ridge_stuff(i,:)');
%end

%figure;

%bar([1:size(ridge_stuff,1)],subject_corr);
%xlabel('Subject');
%ylabel('Correlation');
%title('Similarity between waveforms of RSA and Ridge Regression');
%saveas(gcf,'../../Figures/To_Compare_Meaning.jpg');


figure;
plot(timepoints,mean(ridge_stuff_saliency),'b',timepoints,mean(ridge_stuff_meaning),'r');
hold on;
x=[timepoints,fliplr(timepoints)];
y=[mean(ridge_stuff_saliency)+std(ridge_stuff_saliency),fliplr(mean(ridge_stuff_saliency)-std(ridge_stuff_saliency))];
h=fill(x,y,[0.5 0.5 1],'LineStyle','none');
set(h,'facealpha',.5);
hold on;
y=[mean(ridge_stuff_meaning)+std(ridge_stuff_meaning),fliplr(mean(ridge_stuff_meaning)-std(ridge_stuff_meaning))];
h=fill(x,y,[1 0.5 0.5],'LineStyle','none');
set(h,'facealpha',.5)
hold on; 
plot(timepoints,mean(ridge_stuff_saliency),'b',timepoints,mean(ridge_stuff_meaning),'r');
hold off;
xlabel('Time');
ylabel('Correlation');
legend('Saliency','Meaning');
title('Ridge subject average correlation');
ylim([-0.2,0.6]);
grid on;
saveas(gcf,'../../Figures/RR/Subject_avg.jpg')

figure;
plot(timepoints,mean(ridge_stuff_saliency)./std(ridge_stuff_saliency),'b',timepoints,mean(ridge_stuff_meaning)./std(ridge_stuff_meaning),'r');
xlabel('Time');
ylabel('Effective Correlation(=Mean/Std Dev)');
legend('Saliency','Meaning');
title('Ridge subject effective correlation');
%ylim([-0.2,0.6]);
grid on;
saveas(gcf,'../../Figures/RR/Subject_effective_avg.jpg')


figure;
plot(timepoints,mean(rsa_stuff_saliency),'b',timepoints,mean(rsa_stuff_meaning),'r');
hold on;
x=[timepoints,fliplr(timepoints)];
y=[mean(rsa_stuff_saliency)+std(rsa_stuff_saliency),fliplr(mean(rsa_stuff_saliency)-std(rsa_stuff_saliency))];
h=fill(x,y,[0.5 0.5 1],'LineStyle','none');
set(h,'facealpha',.5);
hold on;
y=[mean(rsa_stuff_meaning)+std(rsa_stuff_meaning),fliplr(mean(rsa_stuff_meaning)-std(rsa_stuff_meaning))];
h=fill(x,y,[1 0.5 0.5],'LineStyle','none');
set(h,'facealpha',.5)
hold on; 
plot(timepoints,mean(rsa_stuff_saliency),'b',timepoints,mean(rsa_stuff_meaning),'r');
hold off;
xlabel('Time');
ylabel('Correlation');
legend('Saliency','Meaning');
title('RSA subject average correlation');
ylim([-0.2,0.6]);
grid on;
saveas(gcf,'../../Figures/RSA/Subject_avg.jpg')

