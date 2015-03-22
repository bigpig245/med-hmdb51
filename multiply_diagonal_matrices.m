function multiply_diagonal_matrices(x)	
	tic;
	checkk = x*x';
	toc;

	tic;
	[row, col] = size(x);
	
	result = zeros(row, row);
	
	for i = 1:row,
		for j = 1:i,
			% mutlitple cells
			for k = 1:col
				result(i, j) = result(i, j) + x(i, k)*x(j,k);
				result(j, i) = result(i, j);
			end
		end
	end
	
	toc;
	
	if isequal(result, checkk),
		fprintf('OK\n');
	end
end
