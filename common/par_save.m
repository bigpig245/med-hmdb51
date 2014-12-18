function par_save( output_file, code, changeperm )
	 if ~exist('changeperm', 'var'),
		changeperm = 0;
	 end
     output_dir = fileparts(output_file);
     if ~exist(output_dir, 'file'),
         mkdir(output_dir);
		 if changeperm == 1,  
			change_perm(output_dir); 
		 end
     end
     save( output_file, 'code');
	 if changeperm == 1, 
		change_perm(output_file); 
	 end
end
