#!/bin/sh

###################################################################################
#
# Title: seqkit.sh
#
# Description: This script reads in a list of sample names to downsample in order to reduce coverage
#
# Usage: bash seqkit.sh <run_name>
# Example: bash seqkit.sh FB_241113_M08451
#
# Author: Richard (Stephen) Bovio (richard.bovio@dshs.texas.gov)
#
# Date created: 2024-11-14
# Last updated: 2024-11-18
#
###################################################################################


# Activate conda environment
source /home/rbovio/miniconda3/etc/profile.d/conda.sh
conda activate seqkit

# Check if the downsample samplesheet is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <run_name>"
    echo "Example: bash seqkit.sh FB_241113_M08451"
    exit 1
fi

base_dir="/home/rbovio/Downsample_FASTQ"
cd $base_dir

# Input file containing the list of FASTQ filenames
downsample_samplesheet="$1_downsample_samplesheet.csv"

# Extract machine and seq_date
IFS='_' read -r project seq_date machine rest <<< $downsample_samplesheet

# Create directory variables
zip_file="FB_${seq_date}_${machine}.zip"
fastq_dir="${base_dir}/downsampled_runs/FB_${seq_date}_${machine}"

# Copy downsample_samplesheet.csv from AWS to EC2 reads directory
echo "Copying downsample_samplesheet.csv from AWS S3 to EC2"
aws s3 cp s3://804609861260-bioinformatics-infectious-disease/Foodborne/DOWNSAMPLE/INPUT_DOWNSAMPLE_SAMPLESHEET/$downsample_samplesheet . --region us-gov-west-1
dos2unix $downsample_samplesheet

# Copy run from AWS to EC2 reads directory
echo "Copying zipped reads from AWS S3 to EC2"
aws s3 cp s3://804609861260-bioinformatics-infectious-disease/Foodborne/$zip_file $base_dir --region us-gov-west-1
unzip $base_dir/$zip_file -d $base_dir/downsampled_runs

# Iterate over each line in the filename list
tail -n +2 $downsample_samplesheet | while IFS=, read -r r1 r2; do
    # Execute seqkit sample for each filename
    sample_name="${r1%%_*}"
    echo "Processing $sample_name..."
    
    # Alternative naming scheme
    r1_new_name="${r1%.fastq.gz}_downsampled.fastq.gz"
    r2_new_name="${r2%.fastq.gz}_downsampled.fastq.gz"
    seqkit sample -n 2000000 -s 42 "$fastq_dir/$r1" -o "$fastq_dir/$r1_new_name" 
    seqkit sample -n 2000000 -s 42 "$fastq_dir/$r2" -o "$fastq_dir/$r2_new_name" 
done

# Zip downsampled samples
cd $fastq_dir
zip -r FB_${seq_date}_${machine}_downsampled.zip *_downsampled.fastq.gz
mv FB_${seq_date}_${machine}_downsampled.zip $base_dir
cd $base_dir

# Copy downsampled samples from EC2 to AWS S3
echo "Copying downsampled samples from EC2 to AWS S3"
aws s3 cp FB_${seq_date}_${machine}_downsampled.zip s3://804609861260-bioinformatics-infectious-disease/Foodborne/DOWNSAMPLE/OUTPUT_FASTQ/ --region us-gov-west-1

# Remove files
rm $zip_file
rm $downsample_samplesheet
rm -rf $fastq_dir
mv FB_${seq_date}_${machine}_downsampled.zip downsampled_runs

# Deactivate conda environment
conda deactivate