load('../../Predictors/Teardrop_Study2_fixed');

l=locations{3};
locationindex=zeros(256,1);
sceneindex=zeros(length(l),1);

for i=1:4
	for j=1:4
		locationindex( ( ((i-1)*4)+j ):16:end,1)=i;
	end
end

a=ones(6,6);
b=ones(7,6)*4;
c=ones(6,7)*2;
d=ones(7,7)*3;
e=reshape([d b;c a],[169,1]);


for i=1:4
	loc=find(e==i);
	[tf,idx]=ismember(intersect(l,loc),l);
	sceneindex(idx)=i;
end

save('../../Predictors/location_index_quadrants','locationindex','sceneindex');
