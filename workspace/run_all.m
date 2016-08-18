clc; clear all; close all;

path_audio = 'audio/';
path_feature = 'feature/';
path_annotation = 'annotation/';
path_estimation = 'estimation/';

files_struct = dir([path_annotation, '*.lab']);
num_audio = length(files_struct);
for i = 1:num_audio
    files{i} = files_struct(i).name(1:end-4);
end

%%
for i = 1:num_audio
    disp(i) 
    audio_filename = [path_audio, files{i},'.wav'];
    feature_filename = [path_feature, files{i},'_cens.mat'];
    annotation_filename = [path_annotation, files{i},'.lab'];
    estimation_filename = [path_estimation, files{i},'.lab'];
    result = audio_segmenter_sf(audio_filename,feature_filename); 
    visualize_results(audio_filename, result, annotation_filename);
    write_results(result, estimation_filename);
end

