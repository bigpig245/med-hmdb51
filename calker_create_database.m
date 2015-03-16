

function calker_create_database()
	dataset_dir = '/home/ntrang/project/dataset/hmdb51';
	
	meta_file = '/home/ntrang/project/output/hmdb51/metadata/metadata.mat';
	if exist(meta_file, 'file'),
		fprintf('File already exist! Skipped\n');
		return;
	end
	
	log(sprintf('Start create database: %s', meta_file));
	events = dir(dataset_dir);
	
	metadata = struct;
	metadata.videos = {};
	metadata.classes = {};
	metadata.classids = [];
	metadata.groups = {};
	metadata.clips = [];
	metadata.labels = {};
	metadata.labelIdxs = {};
	metadata.events = {};
	
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
		list = dir(event_dir);
		ignore_number = 0;
		testing_number = 0;
		training_number = 0;
		
		log(sprintf('Create info for event: %s', event_name));
		
		%all_classes = {};
		for ii = 1:length(list),

			if ~mod(ii, 1000),
				fprintf('%d ', ii);
			end

			file_name = list(ii).name;

			if strcmp(file_name, '.') || strcmp(file_name, '..'),
				continue;	
			end

			%pattern = 'v_(?<class>\w+)_g(?<group>\d+)_c(?<clip>\d+).avi';
			pattern = '(?<group>\w+)_(?<clip>\d+).avi';

			info = regexp(file_name, pattern, 'names');
			if isempty(info),
				   continue;
			end

			video_id = file_name(1:end-4);
			
			% if video is labeled 1, video is used for training
			% if video is labeled 2, video is used for testing
			% if video is labeled 0 then ignore it
			id = find(ismember(video_names, file_name));
			video_label = video_labels(id);
			if video_label == 0,
				log(sprintf('\t>>>>%s is ignore', file_name));
				ignore_number = ignore_number + 1;
				continue;
			end
			if video_label == 1,
				training_number = training_number + 1;
			end
			if video_label == 2,
				testing_number = testing_number + 1;
			end

			metadata.videos = [metadata.videos; video_id];
			metadata.groups = [metadata.groups; info.group];
			metadata.clips = [metadata.clips; str2num(info.clip)];
			metadata.labels = [metadata.labels; video_label];
			metadata.labelIdxs = [metadata.labelIdxs; video_label];
			metadata.classids = [metadata.classids; i-2];
			metadata.events = [metadata.events; event_name];
		end
		metadata.classes = [metadata.classes; event_name];
		log(sprintf('\tTotal ignore: %d files', ignore_number));
		log(sprintf('\tTotal training: %d files', training_number));
		log(sprintf('\tTotal testing: %d files', testing_number));
	end
	metadata.numclass = length(events) - 2;
	%metadata.classNames = classNames;
	save(meta_file, 'metadata');
end

function log (msg)
	fh = fopen('/home/ntrang/project/logs/hmdb51/calker_create_database.log', 'a+');
	msg = [msg, ' at ', datestr(now)];
	fprintf(fh, msg);
	fprintf(fh, '\n');
	fclose(fh);
end
