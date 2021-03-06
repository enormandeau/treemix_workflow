#!/bin/bash

TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
LOG_DIR="10-log_files"
NUM_CPUS=4 

if [[ ! -d "$LOG_DIR" ]]
then
    echo "creating log folder" 
    mkdir 10-log_files
fi

boot_folder="02.boot_results"
if [[ ! -d "$boot_folder" ]]
then
    echo "creating 02.results" 
    mkdir "$boot_folder"
fi

# Treemix options
# Comment options that you don't want
mig=$1 #number of migration event to test 
rout=$2 #name of root 
bootrep=500


# Report if migration is not used
if [ -z "$mig" ]
then
    echo "-----------------------------------"
    echo " running treemix without migration "
    echo "-----------------------------------"
    sleep 1s
fi

# Report if outgroup is not used
if [ -z "$rout" ]
then
    echo "----------------------------------"
    echo " running treemix without outgroup "
    echo "----------------------------------"
    sleep 1s
fi

echo "--------------------------------------"
echo " $bootrep bootsratp will be performed "
echo "--------------------------------------"

# Move to folder
cd "$boot_folder"
mkdir treemix_boot_mig."$mig" 
cd treemix_boot_mig."$mig"
cp ../../00.data/treemix.frq.gz .

# Run bootstrap :
seq $bootrep |parallel -j "$NUM_CPUS" ../../01.scripts/treemix_iterations.sh {} "$mig"

#run ML tree:
#i="-i ../00.data/treemix.frq.gz" #name of input file
#m="-m" #migration
#o="-o out_stem_mig"
#b="-bootstrap"
#k="-k 100"
#se="-se"
#treemix "$i" "$m" "$mig" "$se" "$k" -o out_stem_mig"$mig"    
