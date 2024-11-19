#!/bin/sh

###################################################################################
#
# Title: seqkit.sh
#
# Description: This script reads in a list of sample names to downsample in order to reduce coverage
#
# Usage: bash seqkit.sh <run_name>_downsample_list.csv <reads_dir> <downsample_type> <reads_to_remove>
# Example: bash seqkit.sh TX-M0922-241114_downsample_list.txt reads p 0.5
#
# Author: Richard (Stephen) Bovio (richard.bovio@dshs.texas.gov)
#
# Date created: 2024-11-14
# Last updated: 2024-11-17
#
###################################################################################

# Activate conda environment
source /home/rbovio/miniconda3/etc/profile.d/conda.sh
conda activate seqkit

# Check if the filename list is provided as an argument
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <run_name>_downsample_list.csv <reads_dir> <downsample_type> <reads_to_remove>"
    echo "Example: bash seqkit.sh TX-M0922-241114_downsample_list.csv reads p 0.5"
    exit 1
fi


# Input file containing the list of FASTQ filenames
filename_list=$1
dos2unix $filename_list

# Directory for input/output FASTQ files
reads_dir=$2

# Downsample by number of reads or proportion of reads
downsample_type=$3

# Proportion of reads to downsample
reads_to_remove=$4

# Iterate over each line in the filename list
while IFS=, read -r r1 r2; do
    # Execute seqkit sample for each filename
    name1="${r1%%_*}"
    echo "Processing $name1..."
    seqkit sample -$downsample_type $reads_to_remove -s 42 "$reads_dir/$r1" -o "$reads_dir/downsampled_$r1" 
    seqkit sample -$downsample_type $reads_to_remove -s 42 "$reads_dir/$r2" -o "$reads_dir/downsampled_$r2" 
    
    # # Alternative naming scheme
    # name1="${fastq_filename%%_*}"
    # name2="${fastq_filename#*_}"
    # seqkit sample -$downsample_type $reads_to_remove -1 "$reads_dir/$r1" -2 "$reads_dir/$r2" -o "$reads_dir/downsampled_$r1" -o "$reads_dir/downsampled_$r2"
done < "$filename_list"

# Deactivate conda environment
conda deactivate