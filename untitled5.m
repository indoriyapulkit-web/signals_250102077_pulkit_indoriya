% Reading the original image
clc, clearvars;
i = imread('cursed_schematic.png');

figure
imshow(i)
title('Original Image');

% Spatial filtering
j = medfilt2(i,[3 3]);

figure
imshow(j)
title('After 2D Median Filter');

% 2D FFT magnitude spectrum
f = fft2(j);
f = fftshift(f);

figure
imshow(log(1+abs(f)),[])
title('Frequency Spectrum');

% Constructing frequency mask
s = log(1+abs(f));

[M,N] = size(s);

centerRow = floor(M/2)+1;
centerCol = floor(N/2)+1;

% Ignore low-frequency center
s(centerRow-20:centerRow+20, ...
    centerCol-20:centerCol+20) = 0;

threshold = 0.9 * max(s(:));
[row,col] = find(s > threshold);

mask = ones(size(f));
radius = 5;

for k = 1:length(row)
    r = row(k);
    c = col(k);

    mask(max(1,r-radius):min(M,r+radius), ...
        max(1,c-radius):min(N,c+radius)) = 0;
end

%% Display the frequency mask
figure
imshow(mask,[])
title('Frequency Mask');

%% Show mask applied to spectrum (optional but recommended)
figure
imshow(log(1+abs(f .* mask)),[])
title('Filtered Frequency Spectrum');

%% Recover image
f_filtered = f .* mask;

recovered = real(ifft2(ifftshift(f_filtered)));

figure
imshow(recovered,[])
title('Recovered Image');