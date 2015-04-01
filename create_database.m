function create_database()
	dataset_dir = '/home/ntrang/project/dataset/hmdb51';
	refine_dir = '/home/ntrang/project/dataset/output/refine';
	
	events = dir(dataset_dir);
	
	for i = 1:length(events),
		
		event_name = events(i).name;

		if strcmp(event_name, '.') || strcmp(event_name, '..'),
			continue;	
		end
	
		% load class id from team
		id_f = sprintf('/home/ntrang/project/dataset/testTrainMulti_7030_splits/%s_test_split1.txt', event_name);

		fh = fopen(id_f, 'r');
		infos = textscan(fh, '%s %d');
		fclose(fh);

		video_names = infos{1};
		video_labels = infos{2};
		
		%traverse all videos in event
		event_dir = sprintf('%s/%s', dataset_dir, event_name);
		train_dir = sprintf('%s/%s/%s', refine_dir, 'train', event_name);
		test_dir = sprintf('%s/%s/%s', refine_dir, 'test', event_name);
		ignore_dir = sprintf('%s/%s/%s', refine_dir, 'ignore', event_name);
		mkdir(train_dir);
		mkdir(test_dir);
		mkdir(ignore_dir);
		
		list = dir(event_dir);
		ignore_number = 0;
		testing_number = 0;
		training_number = 0;
		
		%all_classes = {};
		for ii = 1:length(list),

			if ~mod(ii, 1000),
				fprintf('%d ', ii);
			end

			file_name = list(ii).name;

			if strcmp(file_name, '.') || strcmp(file_name, '..'),
				continue;	
			end
			pattern = '(?<group>\w+)_(?<clip>\d+).avi';
			info = regexp(file_name, pattern, 'names');
			if isempty(info),
				continue;
			end

			file_path = sprintf('%s/%s', event_dir, file_name);
			
			% if video is labeled 1, video is used for training
			% if video is labeled 2, video is used for testing
			% if video is labeled 0 then ignore it
			id = find(ismember(video_names, file_name));
			video_label = video_labels(id);
			if video_label == 0,				
				ignore_number = ignore_number + 1;
				copyfile(file_path, ignore_dir);
				continue;
			end
			if video_label == 1,
				training_number = training_number + 1;
				copyfile(file_path, train_dir);
				continue;
			end
			if video_label == 2,
				testing_number = testing_number + 1;
				copyfile(file_path, test_dir);
				continue;
			end
		end
		fprintf('\tTotal ignore: %d files', ignore_number);
		fprintf('\tTotal training: %d files', training_number);
		fprintf('\tTotal testing: %d files\n', testing_number);
	end
end
