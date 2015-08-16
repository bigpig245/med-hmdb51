#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt

conf_arr = [[25,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,14,0,0,0,0,0,0,0,0,0,0,0,0,5,0,6,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0],
[0,0,18,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,2,0,0,0,0,0,0,5,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,4,0,0,0,0],
[1,0,0,0,21,0,0,0,0,1,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,2,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,27,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0],
[0,2,0,1,0,4,11,0,0,2,0,0,0,0,1,0,1,0,0,4,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,2,0,0,0,0,0,16,0,0,0,0,0,0,0,1,2,2,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,2,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,11,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,4,10,0,0,0,0,1],
[0,0,0,0,0,0,2,0,0,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,16,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,2,0,0,0,0,0,0,0,0,1,0,1,2,0,1,0,2,0,0,0,0,0,0,1,1],
[0,0,0,1,0,0,0,0,0,0,5,16,0,0,0,0,0,0,0,0,0,0,2,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1],
[0,1,0,0,0,0,0,4,1,0,0,0,11,0,0,0,1,0,0,0,3,1,0,0,0,0,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,2,1,1,0,0,0,0,0,0,0],
[0,0,1,0,0,0,0,0,0,2,0,0,0,20,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,3,1,0,0,0,0,0],
[0,6,0,0,0,0,1,0,0,4,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0],
[0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0],
[0,0,0,0,2,2,0,2,0,0,0,0,1,2,0,1,1,5,1,2,1,0,0,0,0,0,0,2,1,0,2,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,0,1,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,23,0,1,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
[0,0,0,0,0,1,1,1,0,1,0,0,0,0,1,0,0,1,0,17,1,1,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0],
[0,0,0,0,1,0,0,0,2,1,0,0,3,0,1,0,0,2,0,0,7,0,0,0,0,0,0,2,0,0,0,1,2,0,0,0,0,0,0,0,0,0,0,1,4,2,0,0,1,0,0],
[0,0,0,0,0,0,1,0,0,2,0,0,0,1,0,0,0,0,1,1,1,7,0,0,1,0,0,0,0,0,2,4,1,0,4,0,0,0,0,0,0,1,0,0,1,0,0,1,1,0,0],
[0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,21,1,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0],
[1,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,13,0,2,0,0,0,0,0,0,0,0,1,6,1,0,0,0,2,0,0,0,0,0,1,0,0,0,0],
[0,0,0,0,0,1,1,1,1,0,0,0,2,0,0,1,1,0,0,1,0,0,0,0,8,0,2,0,0,0,0,1,0,1,1,1,0,2,0,0,0,2,2,0,0,0,0,0,0,0,1],
[4,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,2],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,29,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,3,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,21,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0],
[0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,0,21,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,26,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,20,4,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0],
[0,1,0,0,0,0,3,0,0,3,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,17,2,2,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0],
[0,0,0,0,0,0,3,2,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,5,8,0,0,0,0,1,0,0,0,0,2,1,1,0,0,1,0,4,0],
[0,0,0,0,3,0,0,0,0,0,0,1,0,0,0,0,0,0,5,0,1,0,0,0,0,0,0,1,0,0,0,0,0,16,0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,0],
[0,0,3,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,3,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
[0,1,0,0,0,0,0,2,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,3,0,0,0,0,0,0,0,0,1,0,2,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,5,0,0,1,0,0,0,0,0,0,1,0,0,17,0,0,3,0,0,0,0,0,0,1,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,2,0,0,0,0,0,2,1,0],
[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,5,0,0,0,2,0,0,0,0,0,0,0,1,19,0,0,0,0,0,0,0,0,0,0,0,0],
[1,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,10,2,0,0,0,0,0,8,0,0,0,0],
[0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,0,0,0,0,0,3,0,0,0,1],
[0,1,1,0,0,0,1,1,0,0,0,0,0,0,2,0,2,3,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,17,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,4,3,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,17,2,0,0,0,0,0,0,0],
[0,0,3,0,0,0,0,0,0,4,0,0,0,1,0,0,0,1,0,2,0,0,0,0,0,0,0,0,0,0,2,0,1,0,2,0,1,0,0,0,0,0,1,5,0,0,0,7,0,0,0],
[0,1,0,0,0,1,0,0,0,0,0,0,0,2,0,0,0,0,1,0,2,4,0,0,0,0,0,6,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,6,3,0,0,0,1,0],
[1,0,0,0,0,0,0,0,9,0,0,0,0,2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,7,8,0,0,0,0,1],
[0,0,0,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,21,0,0,0,0],
[1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1,1,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,1,0,0,0,0,1,11,3,0,1,3,0,1,0],
[0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,21,1,1],
[0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,3,0,0,0,0,4,1,1,0,0,0,0,0,0,0,1,0,1,0,0,0,2,9,3],
[1,0,0,0,5,0,0,0,1,0,0,3,0,1,0,0,1,0,0,0,0,0,0,4,0,0,0,1,1,0,0,0,0,0,0,2,1,0,0,0,1,0,2,0,0,3,0,0,0,0,3]];

norm_conf = []
for i in conf_arr:
    a = 0
    tmp_arr = []
    a = sum(i, 0)
    for j in i:
        tmp_arr.append(float(j)/float(a))
    norm_conf.append(tmp_arr)

fig = plt.figure()
plt.clf()
ax = fig.add_subplot(111)
ax.set_aspect(1)
res = ax.imshow(np.array(norm_conf), cmap=plt.cm.jet, 
                interpolation='nearest')

width = len(conf_arr)
height = len(conf_arr[0])

for x in xrange(width):
    for y in xrange(height):
        ax.annotate(str(''), xy=(y, x), 
                    horizontalalignment='center',
                    verticalalignment='center')

cb = fig.colorbar(res)
alphabet = ['brush hair','cartwheel', 'catch', 'chew', 'clap', 'climb', 'climb stairs', 'dive', 'draw sword', 'dribble', 'drink', 'eat', 'fall floor', 'fencing', 'flic flac', 'golf', 'handstand', 'hit', 'hug', 'jump', 'kick', 'kick ball', 'kiss', 'laugh', 'pour', 'pullup', 'punch', 'push', 'pushup', 'ride bike', 'ride horse', 'run', 'shake hands', 'shoot ball', 'shoot bow', 'shoot gun', 'sit', 'situp', 'smile', 'smoke', 'somersault', 'stand', 'swing baseball', 'sword', 'sword exercise', 'talk', 'throw', 'turn', 'walk', 'wave']
ax.tick_params(axis='both', which='major', labelsize=6)
ax.tick_params(axis='both', which='minor', labelsize=6)
plt.setp(plt.xticks()[1], rotation=80)
plt.xticks(range(width), alphabet[:height])
plt.yticks(range(height), alphabet[:height])
plt.savefig('confusion_matrix.png', format='png')