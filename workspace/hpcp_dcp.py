# -*- coding: utf-8 -*-

import madmom
from os import walk
from scipy import io


win_len = 0.186
hop_len = 0.14

path_audio = 'C:\\structural analysis\\segmentation\\workspace\\audio\\'
path_feature = 'C:\\structural analysis\\segmentation\\workspace\\feature\\'
for (dirpath, dirnames, filenames) in walk(path_audio):
    break

#%% hpcp
for i in range(len(filenames)):
    print(i)
    sig = madmom.audio.signal.Signal(dirpath+filenames[i])
    fs = madmom.audio.signal.FramedSignal(sig, frame_size=win_len*sig.sample_rate, hop_size=hop_len*sig.sample_rate)
    stft = madmom.audio.stft.STFT(fs)
    spec = madmom.audio.spectrogram.Spectrogram(stft)
    hpcp = madmom.audio.chroma.HarmonicPitchClassProfile(spec, num_classes=12).T
    io.savemat(path_feature+filenames[i][0:-4]+'_hpcp.mat', {'feature' : hpcp})
#%% deepchroma
#for i in range(len(filenames)):
for i in range(len(filenames)):
    print(i)
    dcp = madmom.audio.chroma.DeepChromaProcessor()
    chroma = dcp(dirpath+filenames[i]).T
    io.savemat(path_feature+filenames[i][0:-4]+'_dcp.mat', {'feature' : chroma})