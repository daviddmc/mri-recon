function [x_recon_map, x_map, rmse_map, rmse_spectra] = get_mrsi_map(x_ground_truth,x_recon, startIdx, endIdx)

x = x_ground_truth(:,:,startIdx:endIdx);
x_recon = x_recon(:,:,startIdx:endIdx);

x_map = sum(abs(x),3);
x_recon_map = sum(abs(x_recon),3);

rmse_spectra = 100*norm(x_recon(:)-x(:))/norm(x(:));
rmse_map = 100*norm(x_recon_map(:)-x_map(:))/norm(x_map(:));

