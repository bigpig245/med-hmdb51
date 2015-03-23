#! /bin/bash
echo "cd ~/project/codes/hmdb51" >> run-encode-gmp-index.sh

for i in {1..5100}
do
	((classID = $i / 100 + 1 ))

	for k in {48,18,44,51,46,45,21,9,33,7}
	do
		if [ $k == $classID ]; then
			echo "/usr/local/MATLAB/MATLAB_Production_Server/R2013a/bin/matlab  -nodisplay -r \"imprv_densetraj_encode_gmp_index('hoghof','linear',$i)\" & " >> run-encode-gmp-index.sh
			((modulo = $i % 4 ))

			if [ $modulo == 0 ]; then
				echo "wait" >> run-encode-gmp-index.sh
			fi

		fi
	done
	
done
