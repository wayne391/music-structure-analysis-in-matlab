clear all; clc; close all;

addpath('./MATLAB-Chroma-Toolbox_2.0');
audio_filename = '11_-_All_You_Need_Is_Love.wav';
annotation_filename = '11_-_All_You_Need_Is_Love.lab';

%% Audio Segmentation using Sturcutre Feature

addpath('./sf');
estimation_filename = '11_-_All_You_Need_Is_Love_es_sf.lab';
result_sf = audio_segmenter_sf(audio_filename);
visualize_results(audio_filename, result_sf);
write_results(result_sf, estimation_filename);

%% Audio Segmentation using Checkboard Kernel

addpath('./foote');
estimation_filename = '11_-_All_You_Need_Is_Love_es_foote.lab';
result_foote = audio_segmenter_foote(audio_filename);
visualize_results(audio_filename, result_foote, annotation_filename);
write_results(result_foote, estimation_filename);

%% Saving features to save time

feature = feature_generator( audio_filename, 'clp');
save([audio_filename(1:end-4),'_clp.mat'],'feature');
result_sf = audio_segmenter_sf(audio_filename,[audio_filename(1:end-4),'_clp.mat']);
visualize_results(audio_filename, result_sf);

%% If you have annotations, then you can compare results

visualize_results(audio_filename, result_sf, annotation_filename);