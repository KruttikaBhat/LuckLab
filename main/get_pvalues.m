function get_pvalues(subjects,e_list,timepoints,numscenes,filename)
load(['../../DerivedData/after_ridge_',filename],'final_corr');
load(['../../DerivedData/perm_test_',filename],'random_corr');

pvalue=zeros(length(subjects),length(e_list),length(timepoints));

for i=1:length(subjects)
	tic;
	for j=1:length(e_list)
		for k=1:length(timepoints)
			val=final_corr(i,j,k);
			if final_corr(i,j,k)<0
				val=final_corr(i,j,k)*-1;
			end
			rightTail=sum(random_corr(i,j,k,:)>=val);
			leftTail=sum(random_corr(i,j,k)<=-1*val);
			pvalue(i,j,k)=(rightTail+leftTail)/length(random_corr(i,j,k));
		end
	end
	toc;
end

save(['../../DerivedData/perm_test_',filename],'random_corr','pvalue');

end
