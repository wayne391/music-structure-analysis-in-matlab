clc;clear all;close all;

path_audio = 'audio/';
path_feature = 'feature/';
files_struct = dir([path_audio, '*.wav']);
num_audio = length(files_struct);
for i = 1:num_audio 
    files{i} = files_struct(i).name;
end

%%

for i = 1:num_audio
   disp(i)
   feature = feature_generator([path_audio, files{i}], 'cens');
   save([path_feature, files{i}(1:end-4),'_cens.mat'],'feature');
   
   feature = feature_generator([path_audio, files{i}], 'clp');
   save([path_feature, files{i}(1:end-4),'_clp.mat'],'feature');
   
   feature = feature_generator([path_audio, files{i}], 'crp');
   save([path_feature, files{i}(1:end-4),'_crp.mat'],'feature');
end

disp('DONE!!');