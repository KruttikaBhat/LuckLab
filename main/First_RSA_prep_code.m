function First_RSA_prep_code(read_filename,prep_filename,total_numsubjects,numscenes)

dictin =[read_filename, filesep];
somefiles = dir([dictin, '*.set']);
subjectdata = {};
numberofitems = numscenes;
timepointsnum = 500;
numberofsubs = total_numsubjects;
numberofelectrodes = 59;

for ii = 1:length(somefiles)
    
    EEG = pop_loadset('filename',somefiles(ii).name,'filepath',dictin);

%    EEG = pop_rmbase( EEG, [-500    0]);
%     EEG = pop_eegfiltnew(EEG, 4, 7, [], 0, [], 0);
%     
%     for x = 1:66
%         EEG.data(x,:,:) = abs((hilbert(squeeze(EEG.data(x,:,:))))).^2;
%     end 

    EEG  = pop_basicfilter( EEG,  1:59 , 'Cutoff',  15, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
    trialindex = zeros(1,length(EEG.epoch));
    trialreject = zeros(1,length(EEG.epoch));
    dataindex = [];
    data = [];
    binnumberposition = [];
    EEG = pop_syncroartifacts(EEG, 'Direction', 'bidirectional');
     
    for i = 1:length(EEG.epoch) 
    etype = EEG.epoch(i).eventtype;
    [tfb, indxb] = ismember({'-99' 'boundary'}, etype);
    if sum(tfb) ~= 0
        EEG.reject.rejmanual(i) = 1;
    end
    end

for i = 1:length(EEG.epoch)
   binnumberposition = find(cell2mat(EEG.epoch(i).eventlatency)==0);    
   trialindex(i) =  EEG.epoch(i).eventbini{binnumberposition};
   trialreject(i) = EEG.reject.rejmanual(i);
end

x = 1;

for i = 1:length(EEG.epoch)
   
   if  trialreject(i)  == 0
       data(:,:,x) = EEG.data(1:numberofelectrodes,:,i);
       dataindex(x) = trialindex(i);
       x  = x +1; 
   end  

end

trackeddata = {};

for i = 1:length(dataindex)
    trackeddata{dataindex(i),i} = data(:,:,i);
end

for i = 1:size(trackeddata,1)
 
 currentdata = trackeddata(i,:);
 currentdata(cellfun('isempty',currentdata)) = [];
 %assignin('base',['bin' int2str(i)],currentdata);
 subjectdata{ii,i} = currentdata;
    
end

end


save(prep_filename,'subjectdata','-v7.3');
end
