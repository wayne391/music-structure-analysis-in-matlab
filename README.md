# Music Segmentation in Matlab
Implememtation on two non-NN segmentation algorithms in matlab. Additionally, it contains a toolbox and a workspace for facilitating coding.  
兩種不同音樂分段演算法的實作

Related Topics: Structure Analysis, Recurrence Plot (RP), Self-Similarity Matrix(SSM) 

  
## Dependencies
* Chroma Toolbox (matlab toolbox) [4] : [http://resources.mpi-inf.mpg.de/MIR/chromatoolbox/](http://resources.mpi-inf.mpg.de/MIR/chromatoolbox/)
* mir_eval (python package) [5] : For evaluation (Optional)

Note that there are a warning in origirnal Chroma Toolbox and a little bug that can't read .mp3. I fix it!
## Tutorial
There are two folders<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|- segmentaion toolbox/ : set path and it can be used directly   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|- workspace/ : a template for testing and evaluating a dataset

### segmentaion_toolbox/
Adding this folder to toolbox or addpath, and it's easy to use.
```matlab
audio_filename = 'test.wav';
result = audio_segmenter_sf(audio_filename);
visualize_results(audio_filename, result);
```
see demo.m for further using
  
### workspace/  
If you want to use this template, please follows the structure of folders.  
  
root/    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|- annotation/ : groundtruth or anntations files  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|- audio/ : audio files  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|- estimation/ : results of the program  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|- feature/ : generated features  
  
In the root folder (workspace here), there are three programs. Following the procedures, you can experiments on a dataset.  
  
1. run "feature_saving.m" and generated features  will be placed at the feature folder  
2. run "run_all.m" and the results of prediction will be palced at estimation folder  
3. run "eval.py" to see the performance. (Optional)

Note that the amount of annotation files will dominate the amount of evaluation. To see details in "run_all.m" and "eval.py".
Note that for the reason of copyright, I won't put audio files here.
## Algorithms, Features & Performance
### Algorithms
1. Structure Feature (2012) [1]:    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Feature & Pre-processing  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Recurrence Plot    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Structure Feature  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Novelty Curve & Peak Selection    
2. Checkboard Kernel (2000) [2]:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Feature & Pre-processing  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Self Similarity Matrix    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Gaussian Checkborad  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Novelty Curve & Peak Selection

Generally, it's recommended to use the first one - "Structure Feature". It's still one of most effective segmentation algorithms. However, Checkboard Kernel is simple to implement :).  
### Features
From Chroma Toolbox: CLP, CENS, CRP

To see the influence on performance of chroma feature, please refer to [3] 
Note that there are no MFCC feature, but my function accept customized feature  as input.
I can't find good Harmonic Pitch Class profiles (HPCP) codes in matlab and essentia  is so hard to build. Maybe I'll add this one day.
### Performance
I use "mir_eval" for evaluation. The score is F-score with 3 seconds tolerance.  
* dataset:   
&nbsp;&nbsp;&nbsp;&nbsp;Beatles (174 songs)  
* parameters:  
&nbsp;&nbsp;&nbsp;&nbsp;Chroma Feature: winLenSTMSP = 4410  
&nbsp;&nbsp;&nbsp;&nbsp;Structure Feature (SF): (m, k, st) = (2.5, 0.04, 30)  
&nbsp;&nbsp;&nbsp;&nbsp;Checkboard Kernel (foote): winLen = 64  
  
| Algo          | Feature       | Score    |
| ------------- |:-------------:| --------:|
| SF            | CENS          | 0.706    |
|               | CLP           | 0.722    |
|               | CRP           | 0.700    |
| Foote         | CENS          |          |
|               | CLP           |          |
|               | CRP           | 0.423    |

## References
1. Serrà, J., Müller, M., Grosche, P., & Arcos, J. L. (2012). Unsupervised Detection of Music Boundaries by Time Series Structure Features. In Proc. of the 26th AAAI Conference on Artificial Intelligence (pp. 1613–1619).Toronto, Canada.  
2. Foote, J. (2000). Automatic Audio Segmentation Using a Measure Of Audio Novelty. In Proc. of the IEEE International Conference of Multimedia and Expo (pp. 452–455). New York City, NY, USA.  
3. Nieto, O., Bello, J. P., Systematic Exploration Of Computational Music Structure Research. Proc. of the 17th International Society for Music Information Retrieval Conference (ISMIR). New York City, NY, USA, 2016.
4. Meinard Müller and Sebastian Ewert Chroma Toolbox: MATLAB Implementations for Extracting Variants of Chroma-Based Audio Features Proceedings of the International Conference on Music Information Retrieval (ISMIR), 2011.
5. Colin Raffel, Brian McFee, Eric J. Humphrey, Justin Salamon, Oriol Nieto, Dawen Liang, and Daniel P. W. Ellis, "mir_eval: A Transparent Implementation of Common MIR Metrics", Proceedings of the 15th International Conference on Music Information Retrieval, 2014.
