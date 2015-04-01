function create_results()
	dataset_dir = '/home/ntrang/project/dataset/hmdb51';
	result_dir = '/home/ntrang/project/dataset/output/results';
	result_path = '/home/ntrang/project/output/hmdb51/metadata/results.mat';
	metadata_path = '/home/ntrang/project/output/hmdb51/metadata/metadata_test.mat';

	results = load(result_path);
	results = results.results;

	metadata = load(metadata_path);
	metadata = metadata.metadata;

	for i = 1:length(results.classes),
		
		event_name = results.classes{i};

		event_dir = sprintf('%s/%s', result_dir, event_name);
		success_dir = sprintf('%s/%s', event_dir, 'success');
		fail_dir = sprintf('%s/%s', event_dir, 'fail');
		not_detect_dir = sprintf('%s/%s', fail_dir, 'not detect');
		
		mkdir(event_dir);
		mkdir(fail_dir);
		mkdir(success_dir);
		mkdir(not_detect_dir);

		labels = results.labels{i};
		for ii = 1:length(labels),
			infos = labels(ii, :);
			selected_video_id = infos(1);
			selected_video_name = metadata.videos{selected_video_id};
			selected_event_name = metadata.events{selected_video_id};
			selected_org_video_path = sprintf('%s/%s/%s.%s', dataset_dir, selected_event_name, selected_video_name, 'avi');
			label = infos(2);
			if label == 0,
				detect_wrong_dir = sprintf('%s/%s', fail_dir, selected_event_name);
				mkdir(detect_wrong_dir);
				copyfile(selected_org_video_path, detect_wrong_dir);
			end
			if label == 1,
				copyfile(selected_org_video_path, success_dir);
			end
			if label == 2,
				copyfile(selected_org_video_path, not_detect_dir);
			end
		end
	end
end
