function seg_output = audio_segmenter_sf( filename,chroma,vis, winLenSTMSP, m, k ,st)
    if(nargin < 5)
           m = 2.5;
           k = 0.04;
           st = 30;
    end
    if(nargin < 4) winLenSTMSP = 4410; end
    if(nargin < 3) vis = 0; end
    if(nargin < 2) chroma = 'cens'; end
    if(nargin < 1)
        error('not enough inputs');
    end

    disp('Feature & Pre-processing (1/4)');
    feature = feature_generator(filename, chroma, winLenSTMSP, vis);
    [a, fs] = audioread(filename);    % audio
    X = feature;                        
    [~, No] =size(X);                 % 12 x #frames
    s_total = floor(length(a) / fs);  % total length in seconds
    s_frame = No / s_total;           % #frames per seconds
    mf = round(m*s_frame);            % embbed dimension
    tau = 1;                             
    w = (mf - 1) * tau;                
    N = No - w;                       % N'
    sl = 0.3;
    thres = 0.05;
    lamda = 6;
%% Accounting for the past

    Xd = [];
    for i = w+1:No
        xd = [];
        for j = 0:w
            xd = [xd,X(:,i-j)'];
        end
        xd = xd';
        Xd = [Xd, xd];  
    end
%% Recurrence Plot
    disp('Recurrence Plot (2/4)');
    
    R = recurrence_plot(k, Xd);
    
    if(vis)
        figure;
        colormapSet = generateColormapValue();
        colormap(colormapSet.colormap5);
        imagesc(R);
    end
%% Structure Feature
    disp('Structure Feature (3/4)');

    L = sm_to_time_lag(R);
    
%     if(vis)
%         figure;
%         colormapSet = generateColormapValue();
%         colormap(colormapSet.colormap5);
%         imagesc(L);
%     end
    
    tsl = round(sl*s_frame );
    tst = round(st*s_frame );
    variance = 0.4;
    
    P = kernel_density_estimation_2d(L, tst, tsl, variance);
    
    if(vis)
        figure;
        colormapSet = generateColormapValue();
        colormap(colormapSet.colormap5);
        imagesc(P);
    end
%% Novelty Curve & Peak Selection
    disp('Novelty Curve & Peak Selection (4/4)'); 
    
    c = [];
    for i =1:N-1
        temp = norm(P(i+1,:) - P(i,:)) ^2;
        c = [c, temp];
    end
    c = (c - min(c(:)) + realmin) ./ (max(c(:))-min(c(:)));
    w_shift = round(1+w/2);
    c_final = [c, zeros(1, w_shift)];
    for i = 1:length(c)
        c_final(i+w_shift ) = c(i);
    end

    if(vis)
        figure;
        plot(c_final);
    end
%% Select Peak

    ispeak = ones(1,length(c_final));
    pwin = round(lamda * s_frame);
    for i = 1:length(c_final)
        if (c_final(i) < thres)
            ispeak(i) = 0;
            continue;
        end
        temp = [];
        for j = -pwin:pwin
            if((i + j) > 0 && (i+j) <= length(c_final))  
                temp = [temp, c_final(i+j)];
            end
        end
        if(max(temp) > c_final(i))
            ispeak(i) = 0;
        end
    end
    
    if(vis)
        hold on;
        plot(ispeak, 'g');
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

