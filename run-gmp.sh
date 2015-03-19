#! /bin/bash
echo "cd ~/project/codes/hmdb51" >> run-encode-gmp-index.sh

for i in {3300..5100}
do
	echo "/usr/local/MATLAB/MATLAB_Production_Server/R2013a/bin/matlab  -nodisplay -r \"imprv_densetraj_encode_gmp_index('hoghof','linear',$i)\" & " >> run-encode-gmp-index.sh

	((modulo = $i % 5 ))

	if [ $modulo == 0 ]; then
		echo "wait" >> run-encode-gmp-index.sh
	fi
done
