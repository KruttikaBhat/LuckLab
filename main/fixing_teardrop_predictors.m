function fixing_teardrop_predictors()

load('../../Predictors/Teardrop_Study2');
predictors=whos('predictor*');

new_predictors={};

locations={};
for i=1:5
	tic;
	predictor=eval(predictors(i).name);
%	for j=1:size(predictor,2)
%		if all(~diff(predictor(:,j)))==0
%			break;
%		end
%	end
%	x1=j;
%	for j=size(predictor,2):-1:x1
%		if all(~diff(predictor(:,j)))==0
%			break;
%		end
%	end
%	x2=j;
%	new_predictors{i}=predictor(:,x1:x2);
%	locations(i,:)=[x1 x2];
	temp_predictor=[];
	temp_locations=[];
	for j=1:size(predictor,2)
		if all(~diff(predictor(:,j)))==0 %this checks if there is at least 1 value that's different
		%if length(unique(predictor(:,j)))>=27
			temp_predictor=[temp_predictor predictor(:,j)];
			temp_locations=[temp_locations; j];
		end
	end
	new_predictors{i}=temp_predictor;
	locations{i}=temp_locations;
	toc;
end

save('../../Predictors/Teardrop_Study2_fixed_atleast1','new_predictors','locations');

end
