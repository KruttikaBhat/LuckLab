
bar_data=[];
for i=2:5
load(['../DerivedData/model_correlation/Alexnet_layer' num2str(i)],'all_corr_avg');

data=[];
for j=1:3
data=[data; mean2(all_corr_avg{1}{i})]
end

bar_data=[bar_data data];
end

figure;
bar()
