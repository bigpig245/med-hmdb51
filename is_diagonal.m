% a little banana but let it be -_-
function [result] = is_diagonal(matrix)
	result = 1;
	if ~isempty(matrix),
		R = size(matrix, 1);
		C = size(matrix, 2);
		for i = 1:R,
			for j = 1:C,
				if ~(matrix(i, j) == matrix(j, i)),
					printf('%s, %s', matrix(i,j), matrix(j,i));
					result = 0;
					break;
				end
			end
			if result == 0,
				break;
			end
		end
	end
end

