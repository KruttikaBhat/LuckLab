function label_permutation_test(subjects,e_list,timepoints,numscenes,filename)

load(['../../DerivedData/after_ridge_',filename],'final_ridge','data_idx');

numberofreps=1000;

random_corr=zeros(length(subjects),length(e_list),length(timepoints),numberofreps);
all_permutations=zeros(numberofreps,numscenes);
for rep=1:numberofreps
	scenes=randperm(50);
	while ismember(scenes,all_permutations(1:rep-1,:),'rows')
		scenes=randperm(50);
	end
	all_permutations(rep,:)=scenes;
end

for i=1:length(subjects)
	tic;	
	for j=1:length(e_list)
		parfor k=1:length(timepoints)
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			test_data=[];
			for p=1:numscenes
				test_data=[test_data; file.data(data_idx{1,i,p},:)];
			end
			pred_vals=final_ridge{i,j,k}(1)+test_data(:,2:end)*final_ridge{i,j,k}(2:end);
			corr_values=zeros(numberofreps,1);
			for rep=1:numberofreps
				test_data=[];
				for p=1:numscenes
					test_data=[test_data; file.data(data_idx{1,i,all_permutations(rep,p)},1)];
				end
				corr_values(rep,1)=corr(test_data,pred_vals);
			end
			random_corr(i,j,k,:)=corr_values;
		end
	end
	toc;
end


save(['../../DerivedData/perm_test_',filename],'random_corr');
end
