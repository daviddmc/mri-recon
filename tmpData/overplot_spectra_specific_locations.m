function overplot_spectra_specific_locations(csi1, csi2, data_highres, mask_locations, f_first, f_end, figno_1, figno_2, figno_3)
% csi : input spectra
% mask_location: mask of the locations to be plotted
% f_first, f_end : indices of first and last freqs to show, optional
% figno_1, figno_2 : figure numbers, optional
if nargin < 5
    f_first = 1;
    f_end = size(csi1,3);
end

if nargin < 7
    figno_1 = 1;
    figno_2 = 2;
    figno_3 = 3;
end

N = size(csi1);
max_val_csi1 = max(abs(csi1(:)));
csi1 = csi1/max_val_csi1;
csi2 = csi2/max_val_csi1;

%% Plot the spectra at the right locations

% Determine number of figures
numRow = sum(sum(mask_locations, 2)>0);
numCol = sum(sum(mask_locations,1)>0);

figure(figno_1)
count = 1;
for row = 1:N(1)
    for col = 1:N(2)
        if mask_locations(row,col) == 1
            subplot(numRow,numCol, count)
            hold on, plot(f_first:f_end, abs((squeeze(csi1(row,col, f_first:f_end)))),'r', 'LineWidth', 2); 
            hold on, plot(f_first:f_end, abs((squeeze(csi2(row,col, f_first:f_end)))),'b', 'LineWidth', 2); 
            axis([f_first,f_end, 0, 1 / 1]); 
            axis off;
            count = count + 1;
        end
    end
end

%% Plot the map with dots on the high res data
figure(figno_2);imagesc(abs(data_highres)); axis image off; hold on
N_highres = size(data_highres);
[rowIdx,colIdx] = find(mask_locations==1);
scale = N_highres(1:2)./N(1:2);
startIdx(1) = (1+ scale(1))/2;
startIdx(2) = (1 + scale(2))/2; 
rowIdx_highres = startIdx(1) + (rowIdx-1)*scale(1);
colIdx_highres = startIdx(2) + (colIdx-1)*scale(2);
plot(colIdx_highres,rowIdx_highres, 'r.','MarkerSize', 15); colormap gray

%% Plot the maps (comparison)
csi1_map = sum(abs(csi1(:,:,f_first:f_end)),3);
csi2_map = sum(abs(csi2(:,:,f_first:f_end)),3);
figure(figno_3);imagesc([csi1_map,csi2_map]); axis image off; colorbar
