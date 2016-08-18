function seg_output = audio_segmenter_foote( filename,chroma, vis, winLenSTMSP, winLen )
    if(nargin < 5) winLen = 64; end
    if(nargin < 4) winLenSTMSP = 4410; end
    if(nargin < 3) vis = 0; end
    if(nargin < 2) chroma = 'cens'; end    
    if(nargin < 1)
        error('not enough inputs');
    end
    
    disp('Feature & Pre-processing (1/4)');
    feature = feature_generator(filename, chroma, winLenSTMSP, vis);
    [a, fs] = audioread(filename);
    [~, n] = size(feature);
    s_frame = n / (length(a) / fs);
%% Self Similarity Matrix
    disp('Self Similarity Matrix (2/4)');
    S = self_similarity_matrix(feature);

    if(vis)
        figure;
        colormapSet = generateColormapValue();
        colormap(colormapSet.colormap5);
        imagesc(S);
    end
%% Gaussian Checkborad
    disp('Gaussian Checkborad (3/4)');
    
    variance = 0.4;
    G = gaussian_checkboard(winLen, variance);
    if(vis)
        figure;
        surf(G)
    end
%% Novelty Curve & Peak Selection
    disp('Novelty Curve & Peak Selection (4/4)'); 
    
    nc = zeros(1, n);
    for i = 1 : n - winLen
        nc(i+winLen/2-1) = sum(sum( G.* S(i:i + winLen-1, i:i + winLen-1)));
    end
    nc = (nc - min(nc(:)) + realmin) ./ (max(nc(:))-min(nc(:)));
    

    nc_m = gaussian_filter_1d(nc, winLen, variance);

    

    th = medfilt1(nc_m, winLen);
    ispeak = zeros(1, n);
    for i = 1:n-1
        if((nc_m(i) > nc_m(i+1)) && (nc_m(i) > nc_m(i-1)) && (nc(i) > th(i)))
            ispeak(i) = 1;
        end
    end
    
    if(vis)
        figure;
        plot(nc, 'green')
        hold on
        plot(nc_m, 'r');
        hold on
        plot(th, 'b');
        hold on
        plot(ispeak, 'black');
    end 
%% Output

    seg_output = 0.0;
    for i = 1:length(ispeak)
        if(ispeak(i) ~= 0)
            seg_output = [seg_output, i /s_frame];
        end
    end
    if(seg_output(end) < (length(ispeak) /s_frame - 6))
        seg_output = [seg_output, length(ispeak) /s_frame];
    end
    
    disp('done!!');
    
end

