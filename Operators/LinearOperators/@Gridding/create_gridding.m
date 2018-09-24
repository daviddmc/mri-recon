function A = create_gridding(m)

k_s = m.k_traj;
N_s = size(k_s);
N_c = m.im_size;

k_s = N_c/2 + 1 + N_c .* k_s;

dim = length(N_c);
col_idx = zeros(N_s(1) .* 2^dim, 1);
W = zeros(N_s(1) .* 2^dim, 1);

for ii = 1:2^dim
    offset_i = dec2bin(ii-1,dim) - 48; 
    neighbor = floor(k_s + offset_i);
    
    w = prod(max(1 - abs(k_s - neighbor), 0), 2);
 
    idx_elim = (neighbor < 1) | (neighbor > N_c);
    neighbor(idx_elim) = 1;
    w(any(idx_elim, 2)) = 0;

    idx = 0;
    for jj = dim:-1:2
        idx = (idx + neighbor(:, jj) - 1) * N_c(jj - 1);
    end
    
    col_idx((ii-1)*N_s(1)+1:ii*N_s(1)) = idx + neighbor(:, 1);  
    W((ii-1)*N_s(1)+1:ii*N_s(1)) = w;
end

row_idx = repmat((1:N_s(1))', 2^dim, 1);

A = sparse(row_idx, col_idx, W, N_s(1), prod(N_c));
