clc
clear
close all

load(['data_test.mat'])
BACKBONE = 'resnext101';
SITE = 'ear';

load(['results_test_ippg_to_cppg' SITE '_' BACKBONE])

signal_camera_concat = [];
signal_GT_concat = [];
signal_pred_concat = [];

for j=1:length(CWT_camera_test)
    %% SIGNALS
    if (SITE=="ear")
        CWT_GT = CWT_ear_test{j};
    else
        CWT_GT = CWT_finger_test{j};
    end
    
    signal_GT = icwtlin(CWT_GT);
    signal_camera = icwtlin(CWT_camera_test{j});
    
    temp = CWT_camera_test{j};
    temp.cfs = results{j}.prediction(:,:,1) + 1i*results{j}.prediction(:,:,2);
    signal_pred = icwtlin(temp);
    
    signal_camera_concat = [signal_camera_concat signal_camera];
    signal_GT_concat = [signal_GT_concat signal_GT];
    signal_pred_concat = [signal_pred_concat signal_pred];
    
    
    %% DISPLAY CWT AND RECONSTRUCTED SIGNALS
    figure(1)
    subplot(2,1,1)
    plot(signal_camera)
    legend('camera')
    subplot(2,1,2)
    plot(signal_pred)
    hold on
    plot(signal_GT)
    hold off
    legend('prediction', 'ground truth')
    
    figure(2)
    subplot(3,2,1)
    imagesc(real(CWT_camera_test{j}.cfs))
    title('CWT iPPG - real part')
    subplot(3,2,2)
    imagesc(imag(CWT_camera_test{j}.cfs))
    title('CWT iPPG - imaginary part')
    subplot(3,2,3)
    imagesc(real(CWT_GT.cfs))
    title('CWT GT - real part')
    subplot(3,2,4)
    imagesc(imag(CWT_GT.cfs))
    title('CWT GT - imaginary part')
    subplot(3,2,5)
    imagesc(real(temp.cfs))
    title('CWT prediction - real part')
    subplot(3,2,6)
    imagesc(imag(temp.cfs))
    title('CWT prediction - imaginary part')
    
    disp([int2str(j) '/' int2str(length(results))])
    
%     waitforbuttonpress
end

%% Bland-Altman (amplitudes)
figure
BlandAltman(signal_GT_concat, signal_pred_concat, 2);
xlabel('Signal amplitude (arb. unit)')
ylabel('Difference (arb. unit)')
set(gca,'FontSize',18)
axis([-3 3 -3 3])

%% Scatter plots (amplitudes)
figure
scatter(signal_GT_concat, signal_pred_concat, '.')
hold on
Fit = polyfit(signal_GT_concat, signal_pred_concat,1);
f = polyval(Fit,signal_GT_concat);
plot([min(signal_GT_concat) max(signal_GT_concat)], [min(f) max(f)],'--black', 'linewidth', 1.5)
xlabel('cPPG_{GT} signal amplitude')
ylabel('cPPG_{prediction} signal amplitude')
set(gca,'FontSize',18)
axis([-3 3 -3 3])



