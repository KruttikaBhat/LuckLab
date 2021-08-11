load('../../Data/Saliency_Data.mat');

target_variable = S.saliency_CB;
numberofimages = size(target_variable,3);
[Ysize, Xsize] = size(squeeze(target_variable(:,:,1)));
midpoint=round(Xsize/2);

predictor=zeros(numberofimages,3);

for i=1:numberofimages
	all=squeeze(target_variable(:,:,i));
	left=all(:,1:midpoint);
	right=all(:,midpoint+1:end);
	predictor(i,1)=std(all(:));
	predictor(i,2)=std(left(:));
	predictor(i,3)=std(right(:));
	disp(i);
end

save('../../Predictors/Saliency_CB_stdev','predictor');
