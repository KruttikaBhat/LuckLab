%Change the load and save file locations as well as windowsize and target_variable as required

load('../../Data/Saliency_Data.mat');

windowsize = 128; 
% possible windows = [2,4,8,16,32,64,128,256],;
%for Saliency_Data this would be S.saliency_CB or S.saliency_NCB
%for Meaning_data this would be S.meaning_CB or S.meaning_NCB
target_variable = S.saliency_CB;
numberofimages = size(target_variable,3);

[Ysize, Xsize] = size(squeeze(target_variable(:,:,1)));
Ywindowcounter = (1:windowsize:Ysize-(windowsize-1));
Xwindowcounter = (1:windowsize:Xsize-(windowsize-1));
arraylength = length(Xwindowcounter) * length(Ywindowcounter);

if mod((Ysize/windowsize),1) > 0 || mod((Xsize/windowsize),1) > 0
   error('Pick a window that 768 and 1024 are cleanly divisible by')
end

temppredictor = zeros(length(Ywindowcounter),length(Xwindowcounter));
predictor = zeros(numberofimages,arraylength);

for i = 1:numberofimages
    
    target_array = squeeze(target_variable(:,:,i));
    
    for z = 1:length(Ywindowcounter)
       
        parfor zz = 1:length(Xwindowcounter)
        
            targetbox = target_array(Ywindowcounter(z):Ywindowcounter(z)+windowsize-1,Xwindowcounter(zz):Xwindowcounter(zz)+windowsize-1);
            temppredictor(z,zz) = mean(mean(targetbox));
	end
        
    end
    
    predictor(i,:) = temppredictor(:);
    disp(i)
end

save('../../Predictors/Saliency_predictor_128','predictor');
