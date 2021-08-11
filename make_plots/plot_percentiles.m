subjects=[20];
numscenes=50;
total_numsubjects=32;
timepoints=[1:3:500];
e_list=[11,10,9,8,43,12,13,14,24,23,22,21,59,26,25,27];
left=[11,10,9,8,43,12,13,14];
right=[24,23,22,21,59,26,25,27];

load('../../DerivedData/after_ridge_Meaning_16_622_filtered','final_ridge','data_idx');
load('../../DerivedData/perm_test_Meaning_16_622_filtered','pvalue');

[tf,left_idx]=ismember(left,e_list);
[tf,right_idx]=ismember(right,e_list);

subject=1;

scene=15;

draw_plot(left_idx,left,'left',timepoints,pvalue,final_ridge,data_idx,subject,scene,subjects);
draw_plot(right_idx,right,'right',timepoints,pvalue,final_ridge,data_idx,subject,scene,subjects);

function draw_plot(idx,side_list,side,timepoints,pvalue,final_ridge,data_idx,i,scene,subjects)

for j=1:length(idx)
	tic;
	pred_vals=zeros(1,length(timepoints));
	actual_vals=zeros(1,length(timepoints));
	parfor k=1:length(timepoints)
		file=parload(sprintf(['..', filesep, '..', filesep, 'DerivedData', filesep, 'model_data', filesep, 'Subject_%d', filesep, 'Electrode_%d', filesep, 'Timepoint_%d.mat'], subjects(i),side_list(j),timepoints(k)));
		test_data=file.data(data_idx{1,i,scene},:);
		pred_vals(1,k)=mean(final_ridge{i,idx(j),k}(1)+test_data(:,2:end)*final_ridge{i,idx(j),k}(2:end));
		actual_val(1,k)=mean(test_data(:,1));
	end
	sig_timepoints=squeeze(pvalue(i,idx(j),:))<=0.05;
	figure;
	plot(timepoints,actual_val,'-',timepoints,pred_vals,'-.');
	hold on;
	start_x=0;
	for k=1:length(timepoints)
		if sig_timepoints(k)==1 && start_x==0
			%start_x=timepoints(k);
			start_x=k;
		end
		if sig_timepoints(k)==0 && start_x~=0
			%end_x=timepoints(k-1);
			end_x=k-1;
			patch([timepoints(start_x) timepoints(end_x) timepoints(end_x) timepoints(start_x)], [-1 -1 1 1],[0.9 0.9 0.9]);
			x=timepoints(start_x:end_x);
			yy1=[];
			yy2=[];
			for l=start_x:end_x
				if actual_val(1,l)>pred_vals(1,l)
					yy1=[yy1 actual_val(1,l)];
					yy2=[yy2 pred_vals(1,l)];
				else
					yy1=[yy1 pred_vals(1,l)];
					yy2=[yy2 actual_val(1,l)];
				end
			end
			hold on;
			x=[x,fliplr(x)];
			yy = [yy1,fliplr(yy2)];   % vector of upper & lower boundaries
			fill(x,yy,[0.5 0.5 0.5]);    % fill area defined by x & yy in blue
			hold on;
			start_x=0;
		end
	end
	plot(timepoints,actual_val,'-','color','b');
	hold on;
	plot(timepoints,pred_vals,'-.','color','r');
	grid on;
	hold off;
	ylim([-1 1]);
	xlabel('Time');
	ylabel('Potential');
	legend('actual','predicted');
	title(['Subject ',num2str(subjects(i)),' Electrode ',num2str(side_list(j)),' Scene',num2str(scene)]);
	saveas(gcf,['../../Figures/waveforms/',side,'_',num2str(j),'.jpg']);
	toc;
end

end

