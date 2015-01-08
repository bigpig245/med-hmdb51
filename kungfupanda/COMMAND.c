//trangnt start
//Tạo thông tin về toàn bộ database
calker_create_metadata
Đọc cái này chả hỉu nó nói gì lun, hic...

//Lấy thông tin video, tạo file *.mat chứa thông tin duration và fps của từng video
	get_video_info

//Trích xuất đặc trưng dense trajectory
Có 3 bộ descriptor được định nghĩa: hoghof, mbh, hoghofmbh
	matlabpool open;
	densetraj_select_features('hoghof');
	densetraj_select_features('mbh');
	densetraj_select_features('hoghofmbh');
	matlabpool close;
	do_clustering_gmm('/home/ntrang/project/output/hmdb51','idensetraj.hoghof', 128);
	do_clustering_gmm('/home/ntrang/project/output/hmdb51','idensetraj.mbh', 128);
	do_clustering_gmm('/home/ntrang/project/output/hmdb51','idensetraj.hoghofmbh', 128);

Hiện tại không chạy được code của improve_dense_trajectory nên phải chạy code của dense_trajectory_v1.2
// Gen local scripts
gen_local_scripts('sift_encode_fc_sge', '''hmdb51'', ''video-bg'', ''covdet'', ''hessian'', 256, 80, 0, %d, %d', 24928, 40) 

// cm_gen_local_scripts
cm_gen_local_scripts('sift_encode_bow', '''hmdb51'', ''video-bg'', ''covdet'', ''hessian'', %d, %d', 486, 20)

cm_gen_local_scripts('sift_encode_fc_home_ldc', '''hmdb51'', ''video-bg'', ''covdet'', ''hessian'', ''LDC2012E26'', %d, %d', 98118, 16)

// Hình như lờ các cờ nhíp trong dataset này hem có âm thanh nên hem xài cái ni dc.
cm_gen_local_scripts('mfcc_encode_home_2014', '''video-bg'', ''rastamat'', %d, %d', 100000, 10)

cm_gen_local_scripts('densetraj_encode_sge', '''vsd2014'', ''keyframe-5'', %d, %d', 46058, 20)


// gen_sge_code
// cái này, run chưa nhỉ :|
gen_sge_code('sift_encode_fc_sge', 'hmdb51 video-bg covdet hessian 256 80 0 %d %d', 26424, 500)
gen_sge_code('sift_encode_fc_sge', 'hmdb51 video-bg covdet hessian %d %d', 26424, 500)

gen_sge_code('sift_encode_fc_home_2014', 'hmdb51 video-bg covdet hessian %d %d', 20000, 10)

gen_sge_code('densetraj_encode_sge', 'video-bg %d %d', 4992, 500)
gen_sge_code('densetraj_encode_sge', 'video-bg %d %d', 24928, 500, 4993)

// SIFT
tic; 
matlabpool open;
// Không hỉu trích xuất này lắm, trích ra một mảng 1 nửa có giá trị, 1 nửa giá trị 0
// cái rồi chia 2 ma trận với nhau cuối cùng ra được cái ma trận toàn số 0, ứ hỉu :sosad:
// Tại sao chọn default là màu xám?
sift_select_features('phow', 'gray'); // Trích xuất đặc trưng
matlabpool close;
// training codebook cho đặc trưng
do_clustering_gmm('/home/ntrang/project/output/hmdb51','phow.gray.v14.2.sift'); // Không lưu file proj
do_clustering_gmm('/home/ntrang/project/output/hmdb51','phow.gray.v14.2.sift', 128); // Lưu file lowproj
toc;
sift_encode_fc_home( 'hmdb51', 'video-bg', 'phow', 'gray', 256, 128) // Cái này dành riêng cho sift;

Không hỉu trích xuất có bị sai hay không mà hiện tại ma trận xuất ra có vẻ không giống với lệnh :'(
////////////////////////////////////////////////////////////////////////////////////////////////////
// Trích xuất đặc trưng âm thanh
//Hình như lờ các cờ nhíp trong dataset này hem có âm thanh nên hem xài cái ni dc.
matlabpool open 5;mfcc_select_features('rastamat');matlabpool close;do_clustering_gmm('/home/ntrang/project/tvmed14-tvmed14.2.2','mfcc.bg.rastamat.v14.1');

// Tạo file database
Chạy method calker_create_basic_exp để tạo file database, file này chứa gì chịu -_-, đang si nghĩ

// Vào vấn đề chính
calker_main('hmdb51', 'video-bg', 'idensetraj.mbh', '', 'brush_hair', 'feat_dim', 'ker_type', 'cross');, '--hmdb51-v1.1', 'pool', 5);
calker_main(proj_name, exp_id, feature_ext, suffix, test_pat, feat_dim, ker_type, cross, open_pool)
calker_main('hmdb51', 'brush_hair', 'feat_dim', 'cross', ''); // cái này mới đúng chuẩn nè



// Các vấn đề cần hỏi
1. Dataset cũ như thế nào nhỉ? Cấu trúc thư mục, tên file, đã chia sẵn bộ training và test chưa? Kiểm tra độ chính xác khi chạy thuật toán như thế nào?
	- Dataset mới thì đã chia dữ liệu thành các action rồi, tên file dài thòng. Thường mỗi action cho mỗi event có ít nhất 2 video, hiếm lắm mới có action chỉ có 1 video.
	- Theo các paper chạy dataset này thì có vẻ như họ tự chia dataset theo 30/70.
	- Về training codebook thì có phải là mỗi codebook sẽ chỉ chứa thông tin của 1 event không thôi hay là chứa hết luôn?
	- Khi kiểm tra độ chính xác của bộ test thì kiểm tra như thế nào?
	- Dataset cũ video có vẻ như rất dài, lên đến hơn 400s. Dataset mới video rất ngắn, trung bình từ 2 - 3s, cao nhất là không quá 20s
2. Luồng của thuật toán?
	- Trích xuất đặc trưng > Build codebook > Training (libsvm) > Classify
	- Đầu ra của mỗi bước này là gì?
	
	- Bài toán cũ là trích xuất frame xong sau đó trích xuất đặc trưng từ từng frame.
	- Thuật toán dense_trajectory là trích xuất trực tiếp từ video luôn?
3. Tính độ chính xác như thế nào?

//end



// Cấu trúc chạy thuật toán
calker_main(proj_name, exp_id, feature_ext, varargin) //exp là gì nhỉ
	- ker = calker_build_kerdb: xây dựng cấu trúc database
	- calker_cal_train_kernel(proj_name, exp_name, ker)
		+ calker_load_traindata(proj_name, exp_name, ker)
			> Chuẩn hóa vector (cho từng video), chỉ dùng l1 và l2 norm
			> selected_label là gì nhỉ, có phải là đánh nhãn cho từng video không ta? // nói chung là không hỉu lắm ròi đó -_-
		+ calker_feature_scale(data, scale_params): scale data
		+ Calculate kernel
		+ calcKernel
	- calker_train_kernel(proj_name, exp_name, ker)
		+ Load thông tin database
		+ Training SVM calker_svmkernellearn (oát đờ hợi) -_-
		+ svmflip
	- calker_cal_test_kernel(proj_name, exp_name, ker): khác gì với cái training nhỉ?
	- calker_test_kernel(proj_name, exp_name, ker): same here
	- calker_cal_map(proj_name, exp_name, ker, videolevel): tính toán score cho từng video à?
	- calker_cal_rank(proj_name, exp_name, ker): xếp hạng cho từng video?

	Thặc sự là cũng chả bit hỏi gì rồi đới....... Haizzzzz





// trangnt end
+ dense trajectory:

 matlabpool open;densetraj_select_features('dt');matlabpool close;do_clustering_gmm('/net/per610a/export/das11f/plsang/trecvidmed13','densetraj.mbh.dt.v14.1', 128);

 matlabpool open; tic; densetraj_select_features( 'mhb' ); matlabpool close; do_clustering_gmm('/net/per610a/export/das11f/plsang/trecvidmed13', 'idensetraj.mbh.v14.3', 128); 
	
 matlabpool open; tic; densetraj_select_features( 'hoghof' ); matlabpool close; do_clustering_gmm('/net/per610a/export/das11f/plsang/trecvidmed13', 'idensetraj.hoghof.v14.3', 128);


+ gen_local_scripts:

gen_local_scripts('sift_encode_fc_sge', '''trecvidmed13'', ''video-bg'', ''covdet'', ''hessian'', 256, 80, 0, %d, %d', 24928, 40) 

+ cm_gen_local_scripts

cm_gen_local_scripts('sift_encode_bow', '''trecvidmed14'', ''video-bg'', ''covdet'', ''hessian'', %d, %d', 486, 20)

cm_gen_local_scripts('sift_encode_fc_home_ldc', '''trecvidmed13'', ''video-bg'', ''covdet'', ''hessian'', ''LDC2012E26'', %d, %d', 98118, 16)

cm_gen_local_scripts('mfcc_encode_home_2014', '''video-bg'', ''rastamat'', %d, %d', 100000, 10)

cm_gen_local_scripts('densetraj_encode_sge', '''vsd2014'', ''keyframe-5'', %d, %d', 46058, 20)

+ gen_sge_code:

gen_sge_code('sift_encode_fc_sge', 'trecvidmed13 video-bg covdet hessian 256 80 0 %d %d', 26424, 500)
gen_sge_code('sift_encode_fc_sge', 'trecvidmed13 video-bg covdet hessian %d %d', 26424, 500)

gen_sge_code('sift_encode_fc_home_2014', 'trecvidmed13 video-bg covdet hessian %d %d', 20000, 10)

gen_sge_code('densetraj_encode_sge', 'video-bg %d %d', 4992, 500)
gen_sge_code('densetraj_encode_sge', 'video-bg %d %d', 24928, 500, 4993)

+ SIFT
 tic; matlabpool open; sift_select_features('phow', 'gray');  matlabpool close; do_clustering_gmm('/net/per610a/export/das11f/plsang/trecvidmed13','phow.gray.v14.2.sift'); toc;
 
 sift_encode_fc_home_2014( 'trecvidmed13', 'video-bg', 'covdet', 'hessian', 1, 255)
 
+ mfcc:

matlabpool open 5;mfcc_select_features('rastamat');matlabpool close;do_clustering_gmm('/net/per610a/export/das11f/plsang/trecvidmed13','mfcc.bg.rastamat.v14.1');

+ calker_main

-- tvmed13_v1.1
calker_main('trecvidmed13', 'video-bg', 'densetraj.mbh.idt.v14.1.cb256.fc.pca', 'dim', 65536, 'ek', 'EK130Ex', 'suffix', '--tvmed13-v1.1', 'pool', 5);
calker_main('trecvidmed13', 'video-bg', 'fspace.hesaff.v14.1.sift.cb256.fisher.pca', 'dim', 40960, 'ek', 'EK130Ex', 'suffix', '--tvmed13-v1.1');
calker_main('trecvidmed13', 'video-bg', 'mfcc.rastamat.v14.1.cb256.fc', '--calker-v7-bg', 'kindredtest', 19968, 'kl2', 0, 0);

-- tvmed13_v1.1.3
calker_main('trecvidmed13', 'video-bg', 'covdet.hessian.v14.1.1.sift.cb256.fisher.pca', 'dim', 40960, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3', 'pool', 8);
calker_main('trecvidmed13', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3', 'pool', 5);

calker_main('trecvidmed13', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3', 'pool', 5, 'miss', 'NR'); calker_main('trecvidmed13', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3', 'pool', 5, 'miss', 'RN');

 calker_main('trecvidmed14', 'video-bg', 'mfcc.rastamat.cb256.fc', 'dim', 19968, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'NR'); 
 calker_main('trecvidmed14', 'video-bg', 'mfcc.rastamat.cb256.fc', 'dim', 19968, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'NR');
 
 
+ Adhoc
calker_main('trecvidmed14', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3-ah', 'test', 'evalfull', 'miss', 'RN');
calker_main('trecvidmed14', 'video-bg', 'covdet.hessian.v14.1.1.sift.cb256.fisher.pca', 'dim', 40960, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3-ah', 'test', 'evalfull', 'miss', 'RN');
calker_main('trecvidmed14', 'video-bg', 'mfcc.rastamat.cb256.fc', 'dim', 19968, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3-ah', 'test', 'evalfull', 'miss', 'RN'); 

calker_main('trecvidmed14', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3-ah', 'test', 'evalfull', 'miss', 'RN');
calker_main('trecvidmed14', 'video-bg', 'covdet.hessian.v14.1.1.sift.cb256.fisher.pca', 'dim', 40960, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3-ah', 'test', 'evalfull', 'miss', 'RN');
calker_main('trecvidmed14', 'video-bg', 'mfcc.rastamat.cb256.fc', 'dim', 19968, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3-ah', 'test', 'evalfull', 'miss', 'RN'); 


+++ eval code
calker_main('trecvidmed14', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'RN', 'test', 'evalfull'); calker_main('trecvidmed14', 'video-bg', 'densetrajectory.mbh.cb256.fc', 'dim', 98304, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'RN', 'test', 'evalfull');

calker_main('trecvidmed14', 'video-bg', 'covdet.hessian.v14.1.1.sift.cb256.fisher.pca', 'dim', 40960, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'RN', 'test', 'evalfull'); calker_main('trecvidmed14', 'video-bg', 'covdet.hessian.v14.1.1.sift.cb256.fisher.pca', 'dim', 40960, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'RN', 'test', 'evalfull');

calker_main('trecvidmed14', 'video-bg', 'mfcc.rastamat.cb256.fc', 'dim', 19968, 'ek', 'EK10Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'RN', 'test', 'evalfull'); calker_main('trecvidmed14', 'video-bg', 'mfcc.rastamat.cb256.fc', 'dim', 19968, 'ek', 'EK100Ex', 'suffix', '--tvmed13-v1.1.3', 'miss', 'RN', 'test', 'evalfull');

-- kaori-secode-calker-v7.2
calker_main('trecvidmed13', 'bg', 'densetraj.mbh.idt.v14.1.cb256.fc.pca', '--calker-v7-bg7.2.2', 'kindredtest', 65536, 'kl2', 0, 0);
calker_main('trecvidmed13', 'bg', 'densetraj.mbh.dt.cb256.fc.pca', '--calker-v7-bg7.2.2', 'kindredtest', 65536, 'kl2', 0, 0);
calker_main('trecvidmed13', 'bg', 'covdet.hessian.bg.sift.cb256.fisher.pca', '--calker-v7-bg', 'kindredtest', 40960, 'kl2', 0, 0);
calker_main('trecvidmed13', 'bg', 'fspace.hesaff.v14.1.sift.cb256.fisher.pca', '--calker-v7-bg', 'kindredtest', 40960, 'kl2', 0, 0);


