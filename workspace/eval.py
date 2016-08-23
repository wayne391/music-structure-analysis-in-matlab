# -*- coding: utf-8 -*-
"""
Created on Wed Aug  3 20:15:40 2016

@author: ACER
"""
import mir_eval
import numpy as np
from os import walk
import pandas as pd


path_an = 'C:\structural analysis\segmentation\workspace\\annotation'
path_es = 'C:\structural analysis\segmentation\workspace\estimation'
for (dirpath, dirnames, filenames) in walk(path_es):
    break
#%%
    
score = np.zeros((len(filenames),), dtype=[('filenamme','S50'),('P05', 'f4'), ('R05', 'f4'), ('F05', 'f4'),('P3', 'f4'), ('R3', 'f4'), ('F3', 'f4'),('P', 'f4'), ('R', 'f4'),('F', 'f4'), ('PWP', 'f4'), ('PWR', 'f4'),('PWF', 'f4'), ('So','f4'), ('Su','f4'), ('Sf', 'f4')]); 

for i in range(len(filenames)):
    ref_intervals, ref_labels = mir_eval.io.load_labeled_intervals(path_an + '\\'+filenames[i])
    est_intervals, est_labels = mir_eval.io.load_labeled_intervals(path_es + '\\'+filenames[i])
    # With 0.5s windowing
    [P05, R05, F05] = mir_eval.segment.detection(ref_intervals,est_intervals,window=0.5)
    # With 3s windowing
    [P3, R3, F3] = mir_eval.segment.detection(ref_intervals,est_intervals,window=3)
    
    # Ignoring hits for the beginning and end of track
    [P, R, F] = mir_eval.segment.detection(ref_intervals,est_intervals,window=0.5,trim=True)
    
    ann_inter, ann_labels = mir_eval.util.adjust_intervals(ref_intervals,ref_labels)
    est_inter, est_labels = mir_eval.util.adjust_intervals(est_intervals, est_labels, t_min=0, t_max=ann_inter.max())
    [PWP, PWR, PWF] = mir_eval.segment.pairwise(ann_inter, ann_labels, est_inter, est_labels)
    [So, Su, Sf] = mir_eval.segment.nce(ann_inter, ann_labels, est_inter, est_labels)

    score[i] = (filenames[i],P05, R05, F05,P3, R3, F3,P, R, F, PWP, PWR, PWF, So, Su, Sf)
    
score = pd.DataFrame(score)
Ave_F3 = np.sum(score['F3']) / len(filenames)
Ave_PWF = np.sum(score['PWF']) / len(filenames)
Ave_Sf = np.sum(score['Sf']) / len(filenames)

#%%

f_mean= np.mean(score['F3'])
f_median= np.median(score['F3'])
f_std= np.std(score['F3'])
f_min= np.min(score['F3'])