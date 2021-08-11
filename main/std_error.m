function std_error(subjects,e_list,timepoints,numscenes,filename)

load(['../../DerivedData/after_ridge_',filename],'final_ridge','data_idx');

standard_error=zeros(length(subjects),length(e_list),length(timepoints));
for i=1:length(subjects)
	tic;	
	for j=1:length(e_list)
		parfor k=1:length(timepoints)
			file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),e_list(j),timepoints(k)));
			test_data={};
			pred_vals=zeros(1,numscenes);
			dev=[];
			for p=1:numscenes
				test_data{p}=file.data(data_idx{1,i,p},:);
				pred_vals(1,p)=final_ridge{i,j,k}(1)+test_data{p}(1,2:end)*final_ridge{i,j,k}(2:end);
				dev=[dev; sqrt(sum((test_data{p}(:,1)-repmat(pred_vals(1,p),[size(test_data{p},1),1])).^2)/size(test_data{p},1) )];
				%dev=[dev; sum(abs(test_data{p}(:,1)-repmat(pred_vals(1,p),[size(test_data{p},1),1])))/size(test_data{p},1)];
			end
			error=[];
			for t=1:100
				for p=1:numscenes
					actual_val=test_data{p}(randi([1,size(test_data{p},1)],1,1),1);
					error=[error; (actual_val-pred_vals(1,p))^2];
				end
			end
			standard_error(i,j,k)=mean(error);
		end
	end
	toc;
end

save(['../../DerivedData/std_error_',filename],'standard_error');
end
