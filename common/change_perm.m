function change_perm(file, mod)
	if ~exist('mod', 'var'),
		mod = 777;
	end
	
	try
		if isdir(file),
			cmd = sprintf('chmod -R %d %s', mod, file);
		else
			cmd = sprintf('chmod %d %s', mod, file);
		end
		
		system(cmd);
	catch
	end
end
