set -euo pipefail

# RUN_DIR is YYYYMMDD_TTTT_<custom_name>
# We collect multiple runs into a 'Run Set' YYYYMMDD_<custom_name>
RUN_DIR=$(basename $1)
RUN_SET_DIR="${RUN_DIR:0:9}""${RUN_DIR:14}"

(>&2 echo "RUN_DIR = ""${RUN_DIR}" )
(>&2 echo "RUN_SET_DIR = ""${RUN_SET_DIR}" )

while true; do
    (>&2 echo "Uploading data to: /data/minion/raw_signal/""${RUN_SET_DIR}"/"${RUN_DIR}" ) 
    (>&2 echo "*** Please Terminiate This Transfer When Complete (Ctrl-C) ***" )
    NUM_FILES_TRANSFERRED=$(rsync --verbose --recursive --dirs --remove-source-files --perms --stats\
				  --include "*.fast5" --include "*/" --exclude "*" \
				  --chmod=Do-r,Do-x\
				  $1 minion@sabin.bcgsc.ca:/data/minion/raw_signal/"${RUN_SET_DIR}"/ |\
			    awk '/files transferred/{print $NF}');
    echo "Transferred ""${NUM_FILES_TRANSFERRED}"" files."
    echo "["`date "+%Y-%m-%d %H:%M:%S"`"]" "Waiting 1 minute before next transfer..."
    sleep 60;
done
