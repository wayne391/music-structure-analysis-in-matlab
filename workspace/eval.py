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
    
score = np.zeros((len(filenames),), dtype=[('P05', 'f4'), ('R05', 'f4'), ('F05', 'f4'),('P3', 'f4'), ('R3', 'f4'), ('F3', 'f4'),('P', 'f4'), ('R', 'f4'),('F', 'f4')]); 

for i in range(len(filenames)):
    ref_intervals, _ = mir_eval.io.load_labeled_intervals(path_an + '\\'+filenames[i])
    est_intervals, _ = mir_eval.io.load_labeled_intervals(path_es + '\\'+filenames[i])
    # With 0.5s windowing
    [P05, R05, F05] = mir_eval.segment.detection(ref_intervals,est_intervals,window=0.5)
    # With 3s windowing
    [P3, R3, F3] = mir_eval.segment.detection(ref_intervals,est_intervals,window=3)
    
    # Ignoring hits for the beginning and end of track
    [P, R, F] = mir_eval.segment.detection(ref_intervals,est_intervals,window=0.5,trim=True)
    score[i] = (P05, R05, F05,P3, R3, F3,P, R, F)
    
score = pd.DataFrame(score)
F3_ave = np.sum(score['F3']) / len(filenames)