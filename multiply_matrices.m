function multiply_matrices(x)

	tic;
	% split matrix
	num_edge = 100;
	[row, col] = size(x);
	row_split = compute_block_edge(row, num_edge);
	col_split = compute_block_edge(col, num_edge);
	block = mat2cell(x, row_split, col_split);
	blockT = mat2cell(x', col_split, row_split);
	remain = mod(row, num_edge);
	
	% size of output matrix just depends on size of rows of input matrix
	if row < num_edge,
		num_edge = 0;
	end
	
	% multiply with transpose of each cell
	[rowB, colB] = size(block);
	[rowT, colT] = size(blockT);
	
	if colB ~= rowT
		error('inner dimensions must match');
	end
	result = [];
	
	for i = 1:rowB,
		rowi = [];
		for j = 1:colT,
			% process for the last item
			if i == rowB && j == colT,
				cij = zeros(num_edge + remain, num_edge + remain);
			else
				if i == rowB,
					cij = zeros(num_edge + remain, num_edge);
				else
					if j == colT,
						cij = zeros(num_edge, num_edge + remain);
					else
						cij = zeros(num_edge, num_edge);
					end
				end
			end					
			
			% mutlitple cells
			for k = 1:colB
				b = block(i,k);
				b = b{1};
				bT = blockT(k,j);
				bT = bT{1};
				cij = cij + b*bT;
			end
			% Concatenate each matrix in each cell (block) into one row
			% along columns
			rowi = cat(2, rowi, cij);
		end
		% Concatenate each rows into final matrix
		result = cat(1, result, rowi);
	end
	
	toc;
	
	tic;
	checkk = x*x';
	toc;
	
	if isequal(result, checkk),
		fprintf('OK\n');
	end
end

function block = compute_block_edge(n, num_edge)
	r = fix(n/num_edge);
	m = mod(n, num_edge);
	if r == 0, % if numbers of items < numbers of block, do nothing
		block(1) = m;
	else % split into block
		block = repmat(num_edge, 1, r);
		if ~(m == 0),
			block(r) = block(r) + m;
		end
	end
end


