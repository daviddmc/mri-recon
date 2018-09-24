% N_c here is the size of "oversampled" cartesian data
% Example: A_cart2spiral = create_cart2spiral_operator(k_s, N_s, oversampling_factor*N_c_original,oversampling_factor);
function A_cart2spiral = create_cart2spiral_operator(k_s, N_s, N_c)

% Convert k-space trajectory to matrix indices: Itthi
% row_i = (N_c(1)+1)/2 + (N_c(1)-1)*k_s(:,1);
% col_i = (N_c(2)+1)/2 + (N_c(2)-1)*k_s(:,2);
% z_i = (N_c(3)+1)/2 + (N_c(3)-1)*k_s(:,3);

row_i = (N_c(1)/2+1) + N_c(1)*k_s(:,1);
col_i = (N_c(2)/2+1) + N_c(2)*k_s(:,2);
z_i = (N_c(3)/2+1) + N_c(3)*k_s(:,3);

% Initialization
row_idx_sparse = zeros(N_s(1)*3^3,1);
neighbor_idx_sparse = zeros(N_s(1)*3^3,1);
weight_sparse = zeros(N_s(1)*3^3,1);

% Compute indices of neighbors
count = 1;
for row = -1:1
    for col = -1:1
        for z = -1:1

            row_neighbor_i = floor(row_i+row);
            col_neighbor_i = floor(col_i+col);
            z_neighbor_i = floor(z_i+z);
            
            % Compute weights for kernel (triangular)
            w = max(1-abs(row_i - row_neighbor_i),0).*max(1-abs(col_i - col_neighbor_i),0).*max(1-abs(z_i - z_neighbor_i),0);
            
            % map samples outside the matrix to the edges (put weight = 0)
            % so that samples outside the edge won't contribute
            row_idx_elim = row_neighbor_i<1;
            row_neighbor_i(row_idx_elim) = 1;
            w(row_idx_elim) = 0;
            row_idx_elim = row_neighbor_i>N_c(1);
            row_neighbor_i(row_idx_elim) = N_c(1);
            w(row_idx_elim) = 0;
            
            col_idx_elim = col_neighbor_i<1;
            col_neighbor_i(col_idx_elim) = 1;
            w(col_idx_elim) = 0;
            col_idx_elim = col_neighbor_i>N_c(2);
            col_neighbor_i(col_idx_elim) = N_c(2);
            w(col_idx_elim) = 0;
            
            z_idx_elim = z_neighbor_i<1;
            z_neighbor_i(z_idx_elim) = 1;
            w(z_idx_elim) = 0;
            z_idx_elim = z_neighbor_i>N_c(3);
            z_neighbor_i(z_idx_elim) = N_c(3);
            w(z_idx_elim) = 0;

            % Fast version of sub2idx()
            idx = row_neighbor_i + (col_neighbor_i-1)*N_c(1) + (z_neighbor_i-1)*N_c(1) *N_c(2);

            % Create row indices, col indices, and weights for sparse();
            row_idx_sparse((count-1)*N_s(1)+1:count*N_s(1)) = (1:N_s(1))';
            neighbor_idx_sparse((count-1)*N_s(1)+1:count*N_s(1)) = idx;  
            weight_sparse((count-1)*N_s(1)+1:count*N_s(1)) = w;
            count = count + 1;
        end
    end
end

A_cart2spiral = sparse(row_idx_sparse, neighbor_idx_sparse,weight_sparse, N_s(1), N_c(1)*N_c(2)*N_c(3));