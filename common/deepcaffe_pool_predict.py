import os
import numpy as np
import matplotlib.pyplot as plt
import time
import logging
import pandas as pd
import re
import glob
from os.path import basename
import time
from multiprocessing import Pool

# Make sure that caffe is on the python path:
caffe_root = '/net/per610a/export/das11f/plsang/deepcaffe/caffe-rc' 
import sys
sys.path.insert(0, caffe_root + '/python')

import caffe

REPO_DIRNAME = caffe_root
						   
# Set the right path to your model definition file, pretrained model weights,
# and the image you would like to classify.
MODEL_FILE = '{}/models/bvlc_reference_caffenet/deploy.prototxt'.format(REPO_DIRNAME)
PRETRAINED = '{}/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'.format(REPO_DIRNAME)

net = caffe.Classifier(MODEL_FILE, PRETRAINED,
                       mean=np.load(caffe_root + '/python/caffe/imagenet/ilsvrc_2012_mean.npy'),
                       channel_swap=(2,1,0),
                       raw_scale=255,
                       image_dims=(256, 256))

net.set_phase_test()
net.set_mode_cpu()

default_args = {
	'model_def_file': (
		'{}/models/bvlc_reference_caffenet/deploy.prototxt'.format(REPO_DIRNAME)),
	'pretrained_model_file': (
		'{}/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel'.format(REPO_DIRNAME)),
	'mean_file': (
		'{}/python/caffe/imagenet/ilsvrc_2012_mean.npy'.format(REPO_DIRNAME)),
	'class_labels_file': (
		'{}/data/ilsvrc12/synset_words.txt'.format(REPO_DIRNAME)),
}
for key, val in default_args.iteritems():
	if not os.path.exists(val):
		raise Exception(
			"File for {} is missing. Should be at: {}".format(key, val))
			
default_args['image_dim'] = 227
default_args['raw_scale'] = 255.
default_args['gpu_mode'] = False

with open(default_args['class_labels_file']) as f:
	labels_df = pd.DataFrame([
		{
			'synset_id': l.strip().split(' ')[0],
			'name': ' '.join(l.strip().split(' ')[1:]).split(',')[0]
		}
		for l in f.readlines()
	])
labels = labels_df.sort('synset_id')['name'].values


dataset = 'youcook'
keyframe_dir = '/net/per610a/export/das11f/plsang/{}/keyframes'.format(dataset)
output_dir = '/net/per610a/export/das11f/plsang/{}/feature/keyframes'.format(dataset)
		
def classify_image(kf_file):
	try:
		head, tail = os.path.split(kf_file)	
		kf_name = os.path.splitext(tail)[0]
		head, vid = os.path.split(head)
		
		output_file = '{}/{}/{}.deepcaffe.txt'.format(output_dir, vid, kf_name)
		if os.path.exists(output_file):
			print 'File [{}] already exists'.format(output_file);
			return
		
		output_vdir = '{}/{}'.format(output_dir, vid)
		
		if not os.path.exists(output_vdir):
			os.makedirs(output_vdir)
			
		starttime = time.time()
		input_image = caffe.io.load_image(kf_file)
		scores = net.predict([input_image], oversample=True).flatten()
		endtime = time.time()
					
		indices = (-scores).argsort()[:5]
		predictions = labels[indices]

		preds = [
			(p, '%.5f' % scores[i])
			for i, p in zip(indices, predictions)
		]
		
		with open(output_file, 'w') as fh:
			for (x, y) in preds:
				fh.write('{}:{}\n'.format(x, y))		
		print 'Extracted deep caffe feature for [{}] in {} s.'.format(kf_name, endtime-starttime)

	except Exception as err:
		logging.info('Classification error: %s', err)
		return (False, 'Something went wrong when classifying the '
					   'image. Maybe try another one?')


if __name__=="__main__":
	
	print 'Assembling all key frames'
	
	kf_files = [];
	videos = [vid for vid in os.listdir(keyframe_dir) if re.search('\d{4}', vid)]
	
	for vid in videos:
		kfs = glob.glob("{}/{}/*.jpg".format(keyframe_dir, vid))
		for kf_file in kfs:
			kf_files.append(kf_file);
			
	print 'Pool processing'
	
	pool = Pool(2);
	pool.map(classify_image, kf_files);
	pool.close();
	pool.join();
			
			
			
			
	